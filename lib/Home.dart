import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Watchlist.dart';
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

  @override
  void initState(){
    super.initState();
    selectedDate = DateTime.now();
    _loadStorage();
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
      body: ListView(
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
        FlatButton(
          onPressed: () => goToTab(1, widget.controller),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Open Positions",
                textAlign: TextAlign.start,
                textScaleFactor: 1.5, 
                style: TextStyle(color: Colors.grey[200],)
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: generatePosition("AAPL", "50", ""),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 30),
                child: generatePosition("SNAP", "100", ""),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 30),
                child: Text("more",
                  textScaleFactor: 0.75, 
                  style: TextStyle(color: Colors.grey[200], fontWeight: FontWeight.bold,),
                ),
              )
            ]
          )
        ),
        SizedBox(height: 20),
        ListTile(
          onTap: (){
            if(Navigator != null){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=> Watchlist())
              );
            }
          }, 
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text("Watchlist",
                  textScaleFactor: 1.5, 
                  style: TextStyle(color: Colors.grey[200],)
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 30),
                child: generateWatchListElement("DIS", "never gonna give you up, never gonna let you down. never gonna run around and desert you. never gonna make you cry, never gonna say goodbye. never gonna tell and lie and hurt you"),
              ),
              Container(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 30),
                child: generateWatchListElement("FRC", "oh yeah yeah oh yea yea oh yeah yeah oh yea yea oh yeah yeah oh yea yea oh yeah yeah oh yea yea oh yeah yeah oh yea yea oh yeah yeah oh yea yea oh yeah yeah oh yea yea oh yeah yeah oh yea yea oh yeah yeah oh yea yea"),
              ),
            ]
          ),
        ),
      ],

      )
    );
  } 

  Widget generateWatchListElement(String name, String reason){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(name,
            textScaleFactor: 1.25, 
            style: TextStyle(color: Colors.grey[200],)
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text("Watch Reasons",
            textScaleFactor: 1, 
            style: TextStyle(color: Colors.grey[200],)
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(reason,
            textScaleFactor: 1, 
            style: TextStyle(color: Colors.grey[200],)
          ),
        )
      ]
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
    double updated = ((this._progress + 0.1).clamp(0.0, 1.0) * 100);
    updated = updated.round() / 100;
    if(updated > 1){
      updated = 1;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this._progress = updated;
      prefs.setDouble('_progress', _progress);
    });
  }

  _decrementProgress() async {
    double updated = ((this._progress - 0.1).clamp(0.0, 1.0) * 100);
    updated = updated.round() / 100;
    if(updated < 0){
      updated = 0;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this._progress = updated;
      prefs.setDouble('_progress', _progress);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Color foreground = Colors.blue[200];  
    if(_progress >= 1){
      foreground = Colors.pink[400];
    } else if (_progress >= 0.9) {
      foreground = Colors.purple[900];
    } else if (_progress >= 0.8){
      foreground = Colors.purple[700];
    } else if (_progress >= 0.6){
      foreground = Colors.blue[900];
    } else if (_progress >= 0.5){
      foreground = Colors.blue[800];
    } else if (_progress >= 0.3){
      foreground = Colors.blue[600];
    } else if (_progress >= 0.1) {
      foreground = Colors.blue[400];
    }

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
                value: this._progress,
              ),
              onTap: _incrementProgress,
              onDoubleTap: _decrementProgress,
            ),
          ),
        ),
        Text("${this._progress * 100}%", 
          textScaleFactor: 2, 
          style: TextStyle(color: Colors.grey[100],)
        ),
      ],
    );
  }
}
