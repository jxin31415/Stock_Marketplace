import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Watchlist.dart';
import 'Journal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'util/CircleProgressBar.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
    this.controller,
  }) : super(key: key);

  final TabController controller;

  @override
  HomeState createState() => HomeState(); 
}

class HomeState extends State<Home> {
  DateTime selectedDate;
  Watchlist wl;
  double position;

  @override
  void initState(){
    super.initState();
    selectedDate = DateTime.now();
    _loadStorage();
    wl = Watchlist(location: 0);
    position = 0;
  }

   _loadStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        if(!prefs.containsKey('_lastLogged')){
          prefs.setString('_lastLogged', DateTime.now().toString());
        } else {
          selectedDate = DateTime.parse(prefs.getString('_lastLogged'));
        }
      });
    }
  }

  _updateLastLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('_lastLogged', selectedDate.toString());
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000, 8),
        lastDate: DateTime(2101));
        if (picked != null && picked != selectedDate){
          setState(() {
            selectedDate = picked;
          });
          _updateLastLogged();
        }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[850],
      body: NotificationListener<ScrollUpdateNotification>( child : ListView(
        padding: const EdgeInsets.all(15),
        children: <Widget>[
        Container(
          height: 50,
        ),
        Center(
          child: Text("Account Growth",
            textScaleFactor: 2.5, 
            style: TextStyle(color: Colors.grey[100],)
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Last logged: ",
                  textScaleFactor: 1.25, 
                  style: TextStyle(color: Colors.grey[200], fontStyle: FontStyle.italic,)
                ),
                Text(selectedDate.month.toString() + '/' + selectedDate.day.toString() + '/' + selectedDate.year.toString(),
                  textScaleFactor: 1.25, 
                  style: TextStyle(color: Colors.grey[200], decoration: TextDecoration.underline),
                ),
                SizedBox(width: 5),
                Icon(Icons.calendar_today, color: Colors.white),
              ],
            ),
            onTap: () => _selectDate(context),
          ),
        ),
        Center(
          child: ProgressCard(),
        ),
        SizedBox(height: 30),
        ListTile(
          onTap: () => goToTab(3, widget.controller),
          title: Row(
            children: <Widget>[
              Text("Watchlist",
                textScaleFactor: 1.5, 
                style: TextStyle(color: Colors.grey[200],)
              ),
              Card( margin: EdgeInsets.only(left: 20),
              child: Padding(padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10), child:Text("See More",
                textScaleFactor: 1, 
                style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic,)
              ),),),
            ],
          ),
        ),
        Watchlist(location: 0),
        SizedBox(height: 40),
        ListTile(
          onTap: () => goToTab(1, widget.controller),
          title: Row(
            children: <Widget>[
              Text("Journal",
                textScaleFactor: 1.5, 
                style: TextStyle(color: Colors.grey[200],)
              ),
              Card( margin: EdgeInsets.only(left: 20),
              child: Padding(padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10), child:Text("See More",
                textScaleFactor: 1, 
                style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic,)
              ),),),
            ],
          ),
        ),
        Journal(location: 0),
        SizedBox(height: 20),
      ],
      ),
      onNotification: (notif) {
        position = notif.metrics.pixels;
        return false;
      }
      )
    );
  } 

  Widget generatePosition(String name, String shares, String growth) {
    return Row(
      children: <Widget>[
        Container(
          width: 125,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name,
                textScaleFactor: 1, 
                style: TextStyle(color: Colors.grey[200],)
              ),
              Container(
                height: 20,
              ),
              Text(shares + " shares",
                textScaleFactor: 1, 
                style: TextStyle(color: Colors.grey[200],)
              ),
            ],
          ),
        ),
        Container(
          width: 125,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Position Growth",
                textScaleFactor: 1, 
                style: TextStyle(color: Colors.grey[200],)
              ),
              Container(
                height: 20,
              ),
              Text("+25%/\$250",
                textScaleFactor: 1, 
                style: TextStyle(color: Colors.green[300],)
              ),
            ],
          ),
        ),
      ]
    );
  }

  goToTab(int index, TabController controller) {
    controller.animateTo(index);
  }
}


class ProgressCard extends StatefulWidget {
  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  double _progress;

   @override
  void initState(){
    super.initState();
    _progress = 0;
    _loadStorage();
  }

  _loadStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _progress = (prefs.getDouble('_progress') ?? 0);
    });
  }

  _incrementProgress() async {
    double updated = ((this._progress + 0.1) * 100);
    updated = updated.round() / 100;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this._progress = updated;
      prefs.setDouble('_progress', _progress);
    });
  }

  _decrementProgress() async {
    double updated = ((this._progress - 0.1) * 100);
    updated = updated.round() / 100;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this._progress = updated;
      prefs.setDouble('_progress', _progress);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Color foreground = Colors.blue[200];  
    if(_progress > 0){
      foreground = Colors.green;
    }
    if(_progress < 0){
      foreground = Colors.red;
    }
    int prog = (this._progress * 100).toInt();
    Color background = foreground.withOpacity(0.2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: CircleProgressBar(
                backgroundColor: background,
                foregroundColor: foreground,
                value: this._progress.clamp(-1.0, 1.0),
              ),
              onTap: _incrementProgress,
              onDoubleTap: _decrementProgress,
            ),
          ),
        ),
        Text("$prog%", 
          textScaleFactor: 2, 
          style: TextStyle(color: Colors.grey[100],)
        ),
      ],
    );
  }
}
