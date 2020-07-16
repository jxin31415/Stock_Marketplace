import 'package:flutter/material.dart';

class Journal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[850],
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          Container(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Journal",
                textScaleFactor: 2, 
                style: TextStyle(color: Colors.white)
              ),
              Container(width: 50),
              Container(
                width: 188,
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
            child: Text("Current Positions",
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.white),
            )
          ),
          
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              children: <Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("AAPL (Apple)",
                      textScaleFactor: 1.25,
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(width: 50),
                    Text("+10% / +\$200",
                      textScaleFactor: 1.25,
                      style: TextStyle(color: Colors.green),
                    ),
                  ]
                ),
                SizedBox(height: 10),
                Text("• Shares bought: 500 (2/2/2016)",
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 5),
                Text("• Shares bought: 100 (6/6/2018)",
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" + add entry",
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                    Container(width: 75),
                    Text("Current Position",
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.check_box),
                      onPressed: on_pressed,
                    )
                  ],
                ),
              ],
            ),
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
          Text("more",
            textScaleFactor: 0.75,
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          ),
          Container(height: 75),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Past Positions",
                textScaleFactor: 1.5, 
                style: TextStyle(color: Colors.white)
              ),
              Container(
                alignment: Alignment.center,
                width: 150,
                padding: EdgeInsets.all(2),
                color: Colors.grey[200],
                child: Text("All",
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.grey[800], fontStyle: FontStyle.italic),
                )
              )
            ]
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              children: <Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("NKE (Nike)",
                      textScaleFactor: 1.25,
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(width: 50),
                    Text("+20% / +\$333",
                      textScaleFactor: 1.25,
                      style: TextStyle(color: Colors.green),
                    ),
                  ]
                ),
                SizedBox(height: 10),
                Text("• Shares bought: 200 (2/12/2016)",
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 5),
                Text("• Shares bought: 100 (1/6/2014)",
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" + add entry",
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                    Container(width: 75),
                    Text("Current Position",
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.check_box_outline_blank),
                      onPressed: on_pressed,
                    )
                  ],
                ),
              ],
            ),
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
          Text("more",
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