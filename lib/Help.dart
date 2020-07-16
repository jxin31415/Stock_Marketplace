import 'package:flutter/material.dart';

class Help extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Text("Need Help?",
            textScaleFactor: 2,
            style: TextStyle(
              color: Colors.white         
            )
          ),
          Container(height: 50),
          Text("Contact us at",
            textScaleFactor: 1.5,
            style: TextStyle(
              color: Colors.white         
            )
          ),
          Container(height: 10),
          Container(
            padding: EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(color: Colors.blue[900], borderRadius: BorderRadius.all(Radius.circular(20))),
              child: columnView(),
            ),
          ),
        ]
      )
    );
  } 

  Widget columnView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        mediaItem("2585bhsrobotics@gmail.com", Icons.email),
        mediaItem("(832) 999 - 9999", Icons.phone),
        mediaItem("5100 Maple Street, Bellaire, TX", Icons.store_mall_directory),
      ],
    );
  }

  Widget mediaItem(String contact, IconData icon){
    return Container(
      padding: EdgeInsets.only(left: 25),
      height: 50,
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 25,
          child: Icon(icon, color: Colors.blue[200]),
        ),
        Container(width: 10),
        Text(contact,
          textScaleFactor: 1.5,
          style: TextStyle(
            color: Colors.white         
          )
        ),
      ],
     ),
    );
  }
}