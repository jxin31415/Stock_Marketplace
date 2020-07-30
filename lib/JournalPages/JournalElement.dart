import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Journal.dart';
import '../util/MyAlertDialog.dart';
import 'JournalDialog.dart';

class JournalElement extends StatefulWidget {
  const JournalElement({Key key, this.id, this.ticker, this.entries, this.isCurrent, this.progress, this.currentPrice, this.notes, this.parentState
  }) : super(key: key);

  final int id;
  final String ticker;
  final List<String> entries;
  final bool isCurrent;
  final int progress;
  final int currentPrice;
  final String notes;
  final JournalState parentState;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticker': ticker,
      'entries': (entries.length == 0) ? '' : entries.join(','),
      'isCurrent': isCurrent ? 1 : 0,
      'progress': progress,
      'currentPrice': currentPrice,
      'notes': notes,
    };
  }

  @override
  JournalElementState createState() {
    return JournalElementState(ticker: this.ticker, entries: this.entries, isCurrent: this.isCurrent, progress: this.progress, currentPrice: this.currentPrice, notes: this.notes);
  }
}

class JournalElementState extends State<JournalElement> {

  String ticker;
  List<String> entries;
  bool isCurrent;
  int progress;
  int currentPrice;
  String notes;
  TextEditingController controller;

  final _formKey = GlobalKey<FormState>();

  JournalElementState({this.ticker, this.entries, this.isCurrent, this.progress, this.currentPrice, this.notes});

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
    int dollarValue = progress * 100; // MATH: TO-DO;
    List<Widget> lis = new List();
    lis.add(
      InkWell(
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context){
              List<String> ent = new List();
              ent.addAll(entries);
              return JournalDialog(id: widget.id, ticker: ticker, entries: ent, isCurrent: isCurrent, progress: progress, currentPrice: currentPrice, notes: notes, parentState: this, grandparentState: widget.parentState);
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
    lis.add(Text("$progress% / \$$dollarValue",
      textScaleFactor: 1.25,
      style: TextStyle(color: Colors.green),
    ),);
    lis.add(SizedBox(height: 5));
    if(isCurrent){
      lis.add(Text("Current price: \$$currentPrice",
        textScaleFactor: 1.25,
        style: TextStyle(color: Colors.blue[300]),
      ),);
      lis.add(SizedBox(height: 10));
    }
    if(notes != null && notes != ''){
      lis.add(Text("$notes",
        textScaleFactor: 1.25,
        style: TextStyle(color: Colors.white),
      ),);
    }
    lis.add(SizedBox(height: 10));
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
    if(isCurrent){
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
              await widget.parentState.updateJournal(JournalElement(id: widget.id, ticker: ticker, entries: entries, isCurrent: isCurrent, progress: progress, currentPrice: currentPrice, notes: notes,));
              controller.clear();
            },
          ),
        ),
      );
    }
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


