import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Watchlist.dart';
import '../util/MyAlertDialog.dart';
import 'WatchlistDialog.dart';

class WatchlistElement extends StatefulWidget {
  const WatchlistElement({Key key, this.id, this.ticker, this.title, this.entries, this.parentState
  }) : super(key: key);

  final int id;
  final String ticker;
  final String title;
  final List<String> entries;
  final WatchlistState parentState;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticker': ticker,
      'title': title,
      'entries': (entries.length == 0) ? '' : entries.join(','),
    };
  }

  @override
  WatchlistElementState createState() {
    return WatchlistElementState(ticker: this.ticker, title: this.title, entries: this.entries);
  }
}

class WatchlistElementState extends State<WatchlistElement> {

  String ticker;
  String title;
  List<String> entries;
  TextEditingController controller;

  final _formKey = GlobalKey<FormState>();

  WatchlistElementState({this.ticker, this.title, this.entries});

  @override
  void initState(){
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    List<Widget> lis = new List();
    lis.add(
      InkWell(
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context){
              List<String> ent = new List();
              ent.addAll(entries);
              return WatchlistDialog(id: widget.id, ticker: ticker, title: title, entries: ent, parentState: this, grandparentState: widget.parentState);
            },
          );
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$ticker ",
                style: TextStyle(fontSize: 20),
              ),
              (widget.parentState.widget.location == 1) ? WidgetSpan(
                child: Icon(Icons.edit, size: 24, color: Colors.white),
              ) : TextSpan(),
            ],
          ),
        ),
      ),
    );
    lis.add(SizedBox(height: 5));
    lis.add(Text(title,
      textScaleFactor: 1.25,
      style: TextStyle(color: Colors.green),
    ),);
    lis.add(SizedBox(height: 5));
    for(var i = 0; i < entries.length; i++){
      if(entries[i] != ''){
        lis.add(Text(
          "   • " + entries[i],
          textScaleFactor: 1,
          style: TextStyle(color: Colors.white),
        ));
        lis.add(SizedBox(height: 5),);
      }
    }
    lis.add(SizedBox(height: 10),);
    lis.add(
      Container(
        padding: EdgeInsets.only(left: 20),
        color: Colors.white,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter an entry here'
          ),
          onSubmitted: (String value) async {
            if(mounted){
              setState(() {
                entries.add(value);
              });
            }
            await widget.parentState.updateWatchlist(WatchlistElement(id: widget.id, ticker: ticker, title: title, entries: entries));
            controller.clear();
          },
        ),
      ),
    );
    return Column(
      children: lis,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
}


