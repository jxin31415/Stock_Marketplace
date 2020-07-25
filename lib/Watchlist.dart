import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Watchlist extends StatefulWidget {
  
  const Watchlist({Key key
  }) : super(key: key);

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
        setState(() {
          elements = lis;
          database = db;
          newEntries = new List();
          newTicker = 'Placeholder';
          newTitle = 'Placeholder';
        });
      });
    });
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
      );
    });
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
      where: null,
      whereArgs: null,
    );
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
      lis.add(Container(height: 20,),);
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
      for(var i = 0; i < elements.length; i++){
        lis.add(elements[i]);
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
                    setState((){
                      newTicker = val;
                    });
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
                    setState((){
                      newTitle = val;
                    });
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
                    setState((){
                      if(val != ''){
                        print(val);
                        newEntries.add(val);
                        print(newEntries);
                      }
                    });
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

      lis.add(FlatButton(
        child: Text("CLICK ME TO CLEAR DATABASE"),
        onPressed: () async {
          await deleteWatchlistElement(1);
          setState((){
            watchlistElements().then((lis){
            setState(() {
              elements = lis;
            });
          });
          });
        }
      ));

      return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.purple[900],
            automaticallyImplyLeading: true,
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
        backgroundColor: Colors.grey[850],
        body: ListView(
          padding: EdgeInsets.all(30),
          children: lis,
        )
      );
    } 
  }
}

class WatchlistElement extends StatelessWidget {
  final int id;
  final String ticker;
  final String title;
  final List<String> entries;

  WatchlistElement({this.id, this.ticker, this.title, this.entries});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticker': ticker,
      'title': title,
      'entries': (entries.length == 0) ? '' : entries.join(','),
    };
  }

  @override
  Widget build(BuildContext context){
    List<Widget> lis = new List();
    lis.add(Container(
      child: Text(ticker,
        textScaleFactor: 1.5,
        style: TextStyle(color: Colors.white),
      )
    ),);
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
    lis.add(
      Container(
        padding: EdgeInsets.only(left: 20),
        color: Colors.white,
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter an entry here'
          ),
        ),
      ),
    );
    lis.add(
      SizedBox(height: 5),
    );
    lis.add(Text("+ add entry",
      textScaleFactor: 0.75,
      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
    ),);
    lis.add(Container(height: 20),);
    return Card(
      elevation: 50,
      shadowColor: Colors.purple[700],
      color: Colors.grey[800],
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lis,
        ),
      ),
    );
  }
}