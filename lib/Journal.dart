import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'JournalPages/JournalElement.dart';

class Journal extends StatefulWidget {
  
  const Journal({Key key, this.location,
  }) : super(key: key);

  final int location; // 0 is on home page, 1 is separate page

  @override
  JournalState createState() {
    return JournalState();
  }
}

class JournalState extends State<Journal> {
  
  Database database;
  List<JournalElement> elements;

  final _formKey = GlobalKey<FormState>();
  List<String> newEntries;
  String newTicker;
  bool newIsCurrent;
  int newProgress;
  int newCurrentPrice;
  String newNotes;

  @override
  void initState() {
    super.initState();
    _openDatabase().then((db) {
      journalElements().then((lis){
        if(mounted){
          setState(() {
            elements = lis;
            database = db;
            newEntries = new List();
            newTicker = '';
            newIsCurrent = true;
            newProgress = 0;
            newCurrentPrice = 0;
            newNotes = '';
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
      join(await getDatabasesPath(), 'journal_db.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE journal(id INTEGER PRIMARY KEY AUTOINCREMENT, ticker TEXT, entries TEXT, isCurrent INTEGER, progress INTEGER, currentPrice INTEGER, notes TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertJournalElement(JournalElement element) async {
    // Get a reference to the database.
    final Database db = database;

    await db.insert(
      'journal',
      element.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateJournal(JournalElement element) async {
    // Get a reference to the database.
    final db = database;

    await db.update(
      'journal',
      element.toMap(),
      where: "id = ?",
      whereArgs: [element.id],
    );
  }

  Future<void> deleteJournalElement(int id) async {
    // Get a reference to the database.
    final db = database;
    await db.delete(
      'journal',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<List<JournalElement>> journalElements() async {
    // Get a reference to the database.
    final Database db = database;

    final List<Map<String, dynamic>> maps = await db.query('journal');

    return List.generate(maps.length, (i) {
      String s = maps[i]['entries'];
      return JournalElement(
        id: maps[i]['id'],
        ticker: maps[i]['ticker'],
        entries: s.split(','),
        isCurrent: maps[i]['isCurrent'] == 1,
        progress: maps[i]['progress'],
        currentPrice: maps[i]['currentPrice'],
        notes: maps[i]['notes'],
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
      List<Widget> current = new List();
      List<Widget> past = new List();
      if(widget.location == 1){
        current.add(SizedBox(height: 50));
        current.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Journal",
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
        current.add(Container(height: 50,),);
          current.add(Text("Current Positions",
          textScaleFactor: 1.75, 
          style: TextStyle(color: Colors.white)
        ),);
      }
      if(widget.location == 0){
        for(var i = 0; i < elements.length; i++){
          if(elements[i].isCurrent){
            current.add(Card(
              elevation: 50,
              shadowColor: Colors.purple[700],
              color: Colors.grey[800],
              child: Padding(
                padding: EdgeInsets.all(20),
                child: elements[i],
              ),
            ));
            break;
          }
        }
      } else {
        past.add(SizedBox(height: 10));
        past.add(Divider(color: Colors.deepPurple[200], thickness: 10));
        past.add(SizedBox(height: 140));
        past.add(Text("Past Positions",
          textScaleFactor: 1.75, 
          style: TextStyle(color: Colors.white)
        ),);
        for(var i = 0; i < elements.length; i++){
          if(elements[i].isCurrent){
            current.add(Card(
              elevation: 50,
              shadowColor: Colors.purple[700],
              color: Colors.grey[800],
              child: Padding(
                padding: EdgeInsets.all(20),
                child: elements[i],
              ),
            ));
          } else {
            past.add(Card(
              elevation: 50,
              shadowColor: Colors.purple[700],
              color: Colors.grey[800],
              child: Padding(
                padding: EdgeInsets.all(20),
                child: elements[i],
              ),
            ));
          }
        }
        current.add(SizedBox(height: 20));

        current.add(
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

                  SizedBox(height: 10),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    // inputFormatters: <TextInputFormatter>[
                    //     WhitelistingTextInputFormatter.digitsOnly
                    // ],
                    decoration: const InputDecoration(
                      hintText: 'Enter Current Price',
                    ),

                    validator: (value){
                      if(value.isEmpty){
                        return 'Please enter a number';
                      }
                      var val = int.tryParse(value);
                      print(value);
                      if(val == null){
                        return 'Please enter a valid number with only digits';
                      }
                      return null;
                    },

                    onSaved: (val) {
                      if(mounted){
                        setState((){
                          newCurrentPrice = int.tryParse(val);
                        });
                      }
                    }
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Notes (optional)',
                    ),

                    validator: (value){
                      return null;
                    },

                    onSaved: (val) {
                      if(mounted){
                        setState((){
                          newNotes = val;
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
                  
                  SwitchListTile(
                    title: const Text('Current Position'),
                    value: newIsCurrent,
                    onChanged: (bool val) {
                      setState(() => newIsCurrent = val);
                    }
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          await insertJournalElement(JournalElement(ticker: newTicker, entries: newEntries, isCurrent: newIsCurrent, progress: 0, currentPrice: newCurrentPrice, notes: newNotes));
                          if(mounted){
                            setState((){
                              journalElements().then((lis){
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

      current.addAll(past);

      if(widget.location == 1){
        return new Scaffold(
          backgroundColor: Colors.grey[850],
          body: ListView(
            padding: EdgeInsets.all(30),
            children: current,
          )
        );
      } else {
        return Column(
          children: current,
        );
      }
    } 
  }
}
