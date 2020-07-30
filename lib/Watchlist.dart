import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Watchlist extends StatefulWidget {
  
  const Watchlist({Key key, this.location,
  }) : super(key: key);

  final int location; // 0 is on home page, 1 is separate page

  @override
  WatchlistState createState() {
    return WatchlistState();
  }
}

class WatchlistState extends State<Watchlist> {
  
  Database database;
  List<WatchlistElement> elements;

  final _formKey = GlobalKey<FormState>();
  String newTicker;
  String newTitle;
  List<String> newEntries;

  @override
  void initState() {
    super.initState();
    _openDatabase().then((db) {
      watchlistElements().then((lis){
        if(mounted){
          setState(() {
            elements = lis;
            database = db;
            newEntries = new List();
            newTicker = 'Placeholder';
            newTitle = 'Placeholder';
          });
        }
      });
    });
  }

  @override
  void dispose() {
    if(elements != null){
      for(WatchlistElement each in elements){
        each.controller.dispose();
      }
    }
    super.dispose();
  }

  Future<Database> _openDatabase() async {
    // Open the database and store the reference.
    return database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'watchlist_db.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE watchlist(id INTEGER PRIMARY KEY AUTOINCREMENT, ticker TEXT, title TEXT, entries TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertWatchlistElement(WatchlistElement element) async {
    // Get a reference to the database.
    final Database db = database;

    await db.insert(
      'watchlist',
      element.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateWatchlist(WatchlistElement element) async {
    // Get a reference to the database.
    final db = database;

    await db.update(
      'watchlist',
      element.toMap(),
      where: "id = ?",
      whereArgs: [element.id],
    );
  }

  Future<void> deleteWatchlistElement(int id) async {
    // Get a reference to the database.
    final db = database;
    await db.delete(
      'watchlist',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<List<WatchlistElement>> watchlistElements() async {
    // Get a reference to the database.
    final Database db = database;

    final List<Map<String, dynamic>> maps = await db.query('watchlist');

    return List.generate(maps.length, (i) {
      String s = maps[i]['entries'];
      return WatchlistElement(
        id: maps[i]['id'],
        ticker: maps[i]['ticker'],
        title: maps[i]['title'],
        entries: s.split(','),
        parentState: this,
        controller: TextEditingController(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if(database == null || elements == null){
      return Center(child:SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),);
    } else {
      List<Widget> lis = new List();
      if(widget.location == 1){
        lis.add(SizedBox(height: 50));
        lis.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Watchlist",
              textScaleFactor: 2, 
              style: TextStyle(color: Colors.white)
            ),
            Container(width: 30),
            Container(
              width: 170,
              padding: EdgeInsets.all(5),
              color: Colors.grey[200],
              child: Row(
                children: <Widget>[
                  Icon(Icons.search, color: Colors.black),
                  Text("Search",
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.grey[800], fontStyle: FontStyle.italic),
                  )
                ],
              )
            )
          ]
        ),);
        lis.add(Container(height: 25,),);
      }
      for(var i = 0; i < elements.length && i < 2; i++){
        List<Widget> element = new List();
        element.addAll(elements[i].list(context));
        element.add(SizedBox(height: 5),);
        element.add(
          Container(
            padding: EdgeInsets.only(left: 20),
            color: Colors.white,
            child: TextField(
              controller: elements[i].controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter an entry here'
              ),
              onSubmitted: (String value) async {
                int id = elements[i].id;
                String ticker = elements[i].ticker;
                String title = elements[i].title;
                List<String> entries = elements[i].entries;
                entries.add(value);
                await updateWatchlist(WatchlistElement(id: id, ticker: ticker, title: title, entries: entries));
                if(mounted){
                  setState((){
                    watchlistElements().then((li){
                      setState(() {
                        elements = li;
                      });
                    });
                  });
                }
                elements[i].controller.clear();
              },
            ),
          ),
        );
        lis.add(Card(
          elevation: 50,
          shadowColor: Colors.purple[700],
          color: Colors.grey[800],
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: element,
            ),
          ),
        ));
      }

      if(widget.location == 1){
        for(var i = 2; i < elements.length; i++){
          List<Widget> element = new List();
          element.addAll(elements[i].list(context));
          element.add(SizedBox(height: 5),);
          element.add(
            Container(
              padding: EdgeInsets.only(left: 20),
              color: Colors.white,
              child: TextField(
                controller: elements[i].controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter an entry here'
                ),
                onSubmitted: (String value) async {
                  int id = elements[i].id;
                  String ticker = elements[i].ticker;
                  String title = elements[i].title;
                  List<String> entries = elements[i].entries;
                  entries.add(value);
                  await updateWatchlist(WatchlistElement(id: id, ticker: ticker, title: title, entries: entries));
                  if(mounted){
                    setState((){
                      watchlistElements().then((li){
                        setState(() {
                          elements = li;
                        });
                      });
                    });
                  }
                  elements[i].controller.clear();
                },
              ),
            ),
          );
          lis.add(Card(
            elevation: 50,
            shadowColor: Colors.purple[700],
            color: Colors.grey[800],
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: element,
              ),
            ),
          ));
        }
        lis.add(SizedBox(height: 20));

        lis.add(
          Form(
            key: _formKey,
            child: Card(
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter New Ticker',
                    ),

                    validator: (value){
                      if(value.isEmpty){
                        return 'Please enter a valid ticker';
                      }
                      return null;
                    },

                    onSaved: (val) {
                      if(mounted){
                        setState((){
                          newTicker = val;
                        });
                      }
                    }
                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter New Title',
                    ),

                    validator: (value){
                      if(value.isEmpty){
                        return 'Please enter a valid title';
                      }
                      return null;
                    },

                    onSaved: (val) {
                      if(mounted){
                        setState((){
                          newTitle = val;
                        });
                      }
                    }
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Initial Entry (optional)',
                    ),

                    validator: (value){
                      return null;
                    },

                    onSaved: (val) {
                      if(mounted){
                        setState((){
                          if(val != ''){
                            print(val);
                            newEntries.add(val);
                            print(newEntries);
                          }
                        });
                      }
                    }
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          await insertWatchlistElement(WatchlistElement(ticker: newTicker, title: newTitle, entries: newEntries));
                          if(mounted){
                            setState((){
                              watchlistElements().then((lis){
                                setState(() {
                                  elements = lis;
                                });
                                _formKey.currentState.reset();
                                newEntries.clear();
                              });
                            });
                          }
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),),
              elevation: 50,
              shadowColor: Colors.purple[700],
              color: Colors.white,
            )
          ),
        );

      }

      if(widget.location == 1){
        return new Scaffold(
          backgroundColor: Colors.grey[850],
          body: ListView(
            padding: EdgeInsets.all(30),
            children: lis,
          )
        );
      } else {
        return Column(
          children: lis,
        );
      }
    } 
  }
}

class WatchlistElement {
  final int id;
  final String ticker;
  final String title;
  final List<String> entries;
  final WatchlistState parentState;
  final TextEditingController controller;

  final _formKey = GlobalKey<FormState>();

  WatchlistElement({this.id, this.ticker, this.title, this.entries, this.parentState, this.controller});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticker': ticker,
      'title': title,
      'entries': (entries.length == 0) ? '' : entries.join(','),
    };
  }

  Widget editForm(BuildContext context){
    List<Widget> lis = new List();
    parentState.newEntries = entries;
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
          if(parentState.mounted){
            parentState.setState((){
              parentState.newTicker = val;
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
          if(parentState.mounted){
            parentState.setState((){
              parentState.newTitle = val;
            });
          }
        }
      ),
    );

    lis.add(SizedBox(height:15));
    
    for(var i = 0; i < entries.length; i++){
      if(entries[i] != ''){
        lis.add(RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (){
                    parentState.newEntries[i] = '';
                  }
                ),
              ),
              TextSpan(
                text: entries[i],
                style: TextStyle(fontSize: 20, color: Colors.black),
              )
            ],
          ),
        ));
      }
      lis.add(SizedBox(height: 20));
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
                for(var i = 0; i < parentState.newEntries.length; i++){
                  if(parentState.newEntries[i] == ''){
                    parentState.newEntries.removeAt(i);
                    i--;
                  }
                }
                await parentState.updateWatchlist(WatchlistElement(id: this.id, ticker: parentState.newTicker, title: parentState.newTitle, entries: parentState.newEntries));
                if(parentState.mounted){
                  parentState.setState((){
                    parentState.watchlistElements().then((lis){
                      parentState.setState(() {
                        parentState.elements = lis;
                      });
                      _formKey.currentState.reset();
                      parentState.newEntries.clear();
                    });
                  });
                }
                Navigator.of(context).pop();
              }
            },
            child: Text('Submit'),
          ),
          RaisedButton(
            color: Colors.red,
            onPressed: () async {
              parentState.deleteWatchlistElement(id).then((void d){
                parentState.watchlistElements().then((lis){
                  if(parentState.mounted){
                    parentState.setState(() {
                      parentState.elements = lis;
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

    return AlertDialog(
      backgroundColor: Colors.grey[800],
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
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
          Form(
            key: _formKey,
            child: Card(
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Column(
                mainAxisSize: MainAxisSize.min,
                children: lis,
              ),),
              elevation: 50,
              shadowColor: Colors.purple[700],
              color: Colors.white,
            )
          ),
        ],
      ),
    );
  }

  List<Widget> list(BuildContext context){
    List<Widget> lis = new List();
    lis.add(
      InkWell(
        onTap: (){
          showDialog(
            context: context,
            builder: editForm,
          );
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$ticker ",
                style: TextStyle(fontSize: 20),
              ),
              (parentState.widget.location == 1) ? WidgetSpan(
                child: Icon(Icons.edit, size: 24, color: Colors.white),
              ) : TextSpan(),
            ],
          ),
        ),
      ),
    );
    lis.add(
      SizedBox(height: 15),
    );
    lis.add(
      Container(
        child: Text(title,
          textScaleFactor: 1.25,
          style: TextStyle(color: Colors.white),
        )
      ),
    );
    lis.add(SizedBox(height: 5),);
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
    lis.add(SizedBox(height: 5),);
    return lis;
  }
}