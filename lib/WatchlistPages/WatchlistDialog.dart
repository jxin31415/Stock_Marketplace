import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Watchlist.dart';
import '../util/MyAlertDialog.dart';
import 'WatchlistElement.dart';

class WatchlistDialog extends StatefulWidget {
  const WatchlistDialog({Key key, this.id, this.ticker, this.title, this.entries, this.parentState, this.grandparentState,
  }) : super(key: key);

  final int id;
  final String ticker;
  final String title;
  final List<String> entries;
  final WatchlistElementState parentState;
  final WatchlistState grandparentState;

  @override
  WatchlistDialogState createState() {
    return WatchlistDialogState(ticker: this.ticker, title: this.title, entries: this.entries);
  }
}

class WatchlistDialogState extends State<WatchlistDialog> {

  String ticker;
  String title;
  List<String> entries;

  final _formKey = GlobalKey<FormState>();

  WatchlistDialogState({this.ticker, this.title, this.entries});

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
        decoration: const InputDecoration(
          hintText: 'Enter New Title',
        ),

        initialValue: title,

        validator: (value){
          if(value.isEmpty){
            return 'Please enter a valid title';
          }
          return null;
        },

        onSaved: (val) {
          if(mounted){
            setState((){
              title = val;
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RaisedButton(
            color: Colors.blue,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.grandparentState.updateWatchlist(WatchlistElement(id: widget.id, ticker: ticker, title: title, entries: entries)).then((void d){
                  widget.parentState.setState((){
                    widget.parentState.ticker = ticker;
                    widget.parentState.title = title;
                    widget.parentState.entries = entries;
                    widget.grandparentState.watchlistElements().then((li){
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
              widget.grandparentState.deleteWatchlistElement(widget.id).then((void d){
                widget.grandparentState.watchlistElements().then((li){
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

