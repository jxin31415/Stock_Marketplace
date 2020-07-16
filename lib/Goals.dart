import 'package:flutter/material.dart';

class Goals extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[850],
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          SizedBox(height: 50,),
          Text("Goals",
            textScaleFactor: 2, 
            style: TextStyle(color: Colors.white)
          ),

          SizedBox(height: 25,),
          Text("Tesla 25%",
            textScaleFactor: 1.75, 
            style: TextStyle(color: Colors.white)
          ),

          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Principle: \$1000",
                textScaleFactor: 1.1, 
                style: TextStyle(color: Colors.white)
              ),
              Text("Time: 1/1/20 - 2/8/20",
                textScaleFactor: 1.1, 
                style: TextStyle(color: Colors.white)
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Avg. Growth/Week: \$250",
                textScaleFactor: 1.1, 
                style: TextStyle(color: Colors.white)
              ),
              Text("Avg. Growth/Week: 7%",
                textScaleFactor: 1.1, 
                style: TextStyle(color: Colors.white)
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Total Growth: 25%",
                textScaleFactor: 1.1, 
                style: TextStyle(color: Colors.white)
              ),
              Text("Total Growth: \$1000",
                textScaleFactor: 1.1, 
                style: TextStyle(color: Colors.white)
              ),
            ],
          ),
          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Ideal",
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.25, 
                    style: TextStyle(color: Colors.white)
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 80,
                        alignment: Alignment.center,
                        child: Text("Date",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.25, 
                          style: TextStyle(color: Colors.white)
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue[400], width: 2),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 80,
                        alignment: Alignment.center,
                        child: Text("Growth",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.25, 
                          style: TextStyle(color: Colors.white)
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue[400], width: 2),
                        ),
                      )
                    ],
                  ),
                  genListItem("1/11/18", "\$1234"),
                  genListItem("1/12/18", "\$123"),
                  genListItem("1/13/18", "\$134"),
                  genListItem("1/14/18", "\$14"),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("Current",
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.25, 
                    style: TextStyle(color: Colors.white)
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 80,
                        alignment: Alignment.center,
                        child: Text("Date",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.25, 
                          style: TextStyle(color: Colors.white)
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue[400], width: 2),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 80,
                        alignment: Alignment.center,
                        child: Text("Growth",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.25, 
                          style: TextStyle(color: Colors.white)
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue[400], width: 2),
                        ),
                      )
                    ],
                  ),
                  genListItem("1/11/18", "\$11"),
                  genListItem("1/12/18", "\$13"),
                  genListItem("1/13/18", "\$441"),
                  genListItem("1/14/18", "\$12312"),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),

          Container(
            color: Colors.purple[300],
            child: Text("Graph goes here",
              textAlign: TextAlign.center,
              textScaleFactor: 1.25, 
              style: TextStyle(color: Colors.black)
            ),
          )
        ],
      )
    );
  } 

  Widget genListItem(String date, String growth){
    return Row(
      children: <Widget>[
        Container(
          height: 50,
          width: 80,
          alignment: Alignment.center,
          child: Text(date,
            textAlign: TextAlign.center,
            textScaleFactor: 1, 
            style: TextStyle(color: Colors.white)
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.deepPurple[500],
          ),
        ),
        Container(
          height: 50,
          width: 80,
          alignment: Alignment.center,
          child: Text(growth,
            textAlign: TextAlign.center,
            textScaleFactor: 1, 
            style: TextStyle(color: Colors.white)
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.deepPurple[300],
          ),
        )
      ],
    );
  }
}