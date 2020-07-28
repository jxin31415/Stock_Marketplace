import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

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
  String newTicker;
  List<String> newEntries;
  bool isCurrent;
  int newProgress;

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
            newTicker = 'Placeholder';
            isCurrent = true;
            newProgress = 0;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    if(elements != null){
      for(JournalElement each in elements){
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
      join(await getDatabasesPath(), 'journal_db.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE journal(id INTEGER PRIMARY KEY AUTOINCREMENT, ticker TEXT, entries TEXT, isCurrent TEXT, progress INTEGER)",
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
        isCurrent: maps[i]['isCurrent'] == 'T',
        progress: maps[i]['progress'],
        delete: this,
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
        List<Widget> element = new List();
        for(var i = 0; i < elements.length; i++){
          if(elements[i].isCurrent){
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
                    List<String> entries = elements[i].entries;
                    entries.add(value);
                    await updateJournal(JournalElement(id: elements[i].id, ticker: elements[i].ticker, entries: entries, isCurrent: elements[i].isCurrent, progress: elements[i].progress));
                    if(mounted){
                      setState((){
                        journalElements().then((li){
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
            current.add(Card(
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
                  List<String> entries = elements[i].entries;
                  entries.add(value);
                  await updateJournal(JournalElement(id: elements[i].id, ticker: elements[i].ticker, entries: entries, isCurrent: elements[i].isCurrent, progress: elements[i].progress));
                  if(mounted){
                    setState((){
                      journalElements().then((li){
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
          if(elements[i].isCurrent){
            current.add(Card(
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
          } else {
            past.add(Card(
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
                  
                  SwitchListTile(
                    title: const Text('Current Position'),
                    value: isCurrent,
                    onChanged: (bool val) {
                      setState(() => isCurrent = val);
                    }
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          await insertJournalElement(JournalElement(ticker: newTicker, entries: newEntries, isCurrent: isCurrent, progress: 0));
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

class JournalElement {
  final int id;
  final String ticker;
  final List<String> entries;
  final bool isCurrent;
  final int progress;
  final JournalState delete;
  final TextEditingController controller;


  JournalElement({this.id, this.ticker, this.entries, this.isCurrent, this.progress, this.delete, this.controller});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticker': ticker,
      'entries': (entries.length == 0) ? '' : entries.join(','),
      'isCurrent': isCurrent ? 'T' : 'F',
      'progress': progress,
    };
  }

  List<Widget> list(BuildContext context){
    int dollarValue = progress * 100; // MATH: TO-DO;
    List<Widget> lis = new List();
    lis.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(ticker,
            textScaleFactor: 1.5,
            style: TextStyle(color: Colors.white),
          ),
          Text("$progress% / \$$dollarValue",
            textScaleFactor: 1.25,
            style: TextStyle(color: Colors.green),
          ),
          SizedBox(width: 50),
          (delete.widget.location == 1) ? 
            IconButton(icon: Icon(Icons.delete),
              color: Colors.white,
              onPressed: (){
                delete.deleteJournalElement(id).then((void d){
                  delete.journalElements().then((lis){
                    if(delete.mounted){
                      delete.setState(() {
                        delete.elements = lis;
                      });
                    }
                  });
                });
              }
            ) : (SizedBox(width: 75)),
        ],
        
      ),
    );
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
    lis.add(SizedBox(height: 5),);
    if(delete.widget.location == 1){
      lis.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Current Position",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5),
          IconButton(
            color: Colors.white,
            icon: Icon(isCurrent ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: (){
              delete.updateJournal(JournalElement(id: this.id, ticker: this.ticker, entries: this.entries, isCurrent: !this.isCurrent, progress: this.progress)).then((void d){
                delete.journalElements().then((lis){
                  if(delete.mounted){
                    delete.setState(() {
                      delete.elements = lis;
                    });
                  }
                });
              });
            },
          ),
        ],
      ));
    }
    return lis;
  }
}