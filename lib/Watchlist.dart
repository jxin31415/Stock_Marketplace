import 'package:flutter/material.dart';

class Watchlist extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
        children: <Widget>[
          Container(height: 20,),
          Row(
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
          ),
          Container(height: 25),
          Container(
            child: Text("DIS",
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.white),
            )
          ),
          Container(height: 20),
          Container(
            child: Text("Wait Reason",
              textScaleFactor: 1.25,
              style: TextStyle(color: Colors.white),
            )
          ),
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
          SizedBox(height: 5),
          Text("+ add entry",
            textScaleFactor: 0.75,
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          ),
          Container(height: 75),

          Container(
            child: Text("Ticker",
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.white),
            )
          ),
          Container(height: 20),
          Container(
            child: Text("Title",
              textScaleFactor: 1.25,
              style: TextStyle(color: Colors.white),
            )
          ),
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
          SizedBox(height: 5),
          Text("+ add entry",
            textScaleFactor: 0.75,
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          ),
        ]
      )
    );
  } 

  void on_pressed () {
  }

  void on_changed(dynamic){

  }
}