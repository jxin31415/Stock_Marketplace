import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'WatchlistPages/WatchlistElement.dart';


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
        lis.add(Card(
          elevation: 50,
          shadowColor: Colors.purple[700],
          color: Colors.grey[800],
          child: Padding(
            padding: EdgeInsets.all(20),
            child: elements[i],
          ),
        ));
      }

      if(widget.location == 1){
        for(var i = 2; i < elements.length; i++){
          lis.add(Card(
          elevation: 50,
          shadowColor: Colors.purple[700],
          color: Colors.grey[800],
          child: Padding(
              padding: EdgeInsets.all(20),
              child: elements[i],
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
                            newEntries.add(val);
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