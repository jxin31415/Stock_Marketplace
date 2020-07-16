import 'package:flutter/material.dart';

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[850],
      body: ListView(
        padding: EdgeInsets.all(30),
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            Container(height: 50,),
            Container(
              height: 60,
              child: Text("Settings",
                textScaleFactor: 2,
                style: TextStyle(
                  color: Colors.white         
                )
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: Colors.purple[600], borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text("Notifications",
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: Colors.white         
                )
              ),
            ),
            Container(height: 20,),
            rowView("Repeat", "Every day", 1),
            rowView("Current Price", "XYZ, ABC", 1),
            rowView("Time", "9:40 AM", 1),
            Container(height: 20,),
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 50,
              decoration: BoxDecoration(color: Colors.purple[600], borderRadius: BorderRadius.all(Radius.circular(10))),
              child: rowView("Portfolio", "My Portfolio", 1.25),
            ),
            Container(height: 20,),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: Colors.purple[600], borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text("Font Size",
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: Colors.white         
                )
              ),
            ),
            Container(height: 20,),
            Container(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container( 
                    width: 50,
                    child: Text("Aa",
                      textScaleFactor: 1.25,
                      style: TextStyle(
                        color: Colors.white         
                      )
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Text("Aa",
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        color: Colors.white         
                      )
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Text("Aa",
                      textScaleFactor: 1.75,
                      style: TextStyle(
                        color: Colors.white         
                      )
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Text("Aa",
                      textScaleFactor: 2,
                      style: TextStyle(
                        color: Colors.white         
                      )
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Text("Aa",
                      textScaleFactor: 2.25,
                      style: TextStyle(
                        color: Colors.white         
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).toList(),
      ),
    );
  } 

  Widget rowView(String query, String value, double scale){
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container( 
            width: 125,
            child: Text(query,
              textScaleFactor: scale,
              style: TextStyle(
                color: Colors.white         
              )
            ),
          ),
          Container(
            width: 125,
            child: Text(value,
              textScaleFactor: scale,
              style: TextStyle(
                color: Colors.white         
              )
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
  }
}