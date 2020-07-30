import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Journal.dart';
import '../util/MyAlertDialog.dart';
import 'JournalElement.dart';

class JournalDialog extends StatefulWidget {
  const JournalDialog({Key key, this.id, this.ticker, this.entries, this.isCurrent, this.progress, this.currentPrice, this.notes, this.parentState, this.grandparentState,
  }) : super(key: key);

  final int id;
  final String ticker;
  final List<String> entries;
  final bool isCurrent;
  final int progress;
  final int currentPrice;
  final String notes;
  final JournalElementState parentState;
  final JournalState grandparentState;

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
  JournalDialogState createState() {
    return JournalDialogState(ticker: this.ticker, entries: this.entries, isCurrent: this.isCurrent, progress: this.progress, currentPrice: this.currentPrice, notes: this.notes);
  }
}

class JournalDialogState extends State<JournalDialog> {

  String ticker;
  List<String> entries;
  bool isCurrent;
  int progress;
  int currentPrice;
  String notes;

  final _formKey = GlobalKey<FormState>();

  JournalDialogState({this.ticker, this.entries, this.isCurrent, this.progress, this.currentPrice, this.notes});

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    List<Widget> lis = new List();
    lis.add(
      TextFormField(
        decoration: const InputDecoration(
          hintText: 'Enter New Ticker',
        ),

        initialValue: ticker,

        validator: (value){
          if(value.isEmpty){
            return 'Please enter a valid ticker';
          }
          return null;
        },

        onSaved: (val) {
          if(mounted){
            setState((){
              ticker = val;
            });
          }
        }
      ),
    );

    lis.add(
      TextFormField(
        keyboardType: TextInputType.number,
        // inputFormatters: <TextInputFormatter>[
        //     WhitelistingTextInputFormatter.digitsOnly
        // ],
        decoration: const InputDecoration(
          hintText: 'Enter Current Price',
        ),

        initialValue: '$currentPrice',

        validator: (value){
          if(value.isEmpty){
            return 'Please enter a number';
          }
          var val = int.tryParse(value);
          if(val == null){
            return 'Please enter a valid number with digits';
          }
          return null;
        },

        onSaved: (val) {
          if(mounted){
            setState((){
              currentPrice = int.tryParse(val);
            });
          }
        }
      ),
    );

    lis.add(
      TextFormField(
        decoration: const InputDecoration(
          hintText: 'Enter Notes (optional)',
        ),

        initialValue: (notes == null) ? '' : notes,

        validator: (value){
          return null;
        },

        onSaved: (val) {
          if(mounted){
            setState((){
              notes = val;
            });
          }
        }
      ),
    );
    lis.add(SizedBox(height: 5));
    for(var i = 0; i < entries.length; i++){
      if(entries[i] != ''){
        lis.add(RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (){
                    if(mounted){
                      setState((){
                        entries.removeAt(i);
                      });
                    }
                  }
                ),
              ),
              TextSpan(
                text: " •  " + entries[i],
                style: TextStyle(fontSize: 15, color: Colors.black),
              )
            ],
          ),
        ));
      }
    }

    lis.add(
      SwitchListTile(
        title: const Text('Current Position'),
        value: isCurrent,
        onChanged: (bool val) {
          setState(() => isCurrent = val);
        }
      ),
    );

    lis.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RaisedButton(
            color: Colors.blue,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.grandparentState.updateJournal(JournalElement(id: widget.id, ticker: ticker, entries: entries, isCurrent: isCurrent, progress: 0, currentPrice: currentPrice, notes: notes)).then((void d){
                  widget.parentState.setState((){
                    widget.parentState.ticker = ticker;
                    widget.parentState.entries = entries;
                    widget.parentState.isCurrent = isCurrent;
                    widget.parentState.progress = progress;
                    widget.parentState.currentPrice = currentPrice;
                    widget.parentState.notes = notes;
                    widget.grandparentState.journalElements().then((li){
                      if(widget.grandparentState.mounted){
                        widget.grandparentState.setState(() {
                          widget.grandparentState.elements = li;
                        });
                      }
                    });
                  });
                });
                _formKey.currentState.reset();
                Navigator.of(context).pop();
              }
            },
            child: Text('Submit'),
          ),
          RaisedButton(
            color: Colors.red,
            onPressed: () async {
              widget.grandparentState.deleteJournalElement(widget.id).then((void d){
                widget.grandparentState.journalElements().then((li){
                  if(widget.grandparentState.mounted){
                    widget.grandparentState.setState(() {
                      widget.grandparentState.elements = li;
                    });
                  }
                });
              });
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );

    return MyAlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -20.0,
            top: -20.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Card(
                child: Container(
                  height: 400,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
                    child: ListView(
                      children: lis,
                      shrinkWrap: true,
                    ),
                  ),
                ),
                elevation: 50,
                shadowColor: Colors.purple[700],
                color: Colors.white,
              )
            ),
          ),
        ],
      ),
    );
  }
}

