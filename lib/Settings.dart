import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Settings extends StatefulWidget {
  const Settings({
    Key key,
    this.notif_daily,
    this.notif_weekly,
    this.cancel_notif,
  }) : super(key: key);

  final Function notif_daily;
  final Function notif_weekly;
  final Function cancel_notif;

  @override
  SettingsState createState() => SettingsState(); 
}

class SettingsState extends State<Settings> {

  String weekly;
  String time;

  @override
  void initState(){
    super.initState();
    weekly = 'None';
    time = "10:00";
    _loadStorage();
  }

   _loadStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        if(!prefs.containsKey('_notificationWeekly')){
          prefs.setString('_notificationWeekly', 'None');
        } else {
          weekly = prefs.getString('_notificationWeekly');
        }
        if(!prefs.containsKey('_notifTime')){
          prefs.setString('_notifTime', "10:00");
        } else {
          time = prefs.getString('_notifTime');
        }
      });
    }
  }

  _updateNotif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        prefs.setString('_notificationWeekly', weekly);
        prefs.setString('_notifTime', time);

        int t = int.parse(time.substring(0, 2));
        if(weekly == 'None'){
          widget.cancel_notif();
        } else if (weekly == "Every Day"){
          widget.notif_daily(t);
        } else {
          switch (weekly){
            case "Every Monday": {
              widget.notif_weekly(Day.Monday, t);
            }
            break;

            case "Every Tuesday": {
              widget.notif_weekly(Day.Tuesday, t);
            }
            break;

            case "Every Wednesday": {
              widget.notif_weekly(Day.Wednesday, t);
            }
            break;

            case "Every Thursday": {
              widget.notif_weekly(Day.Thursday, t);
            }
            break;

            case "Every Friday": {
              widget.notif_weekly(Day.Friday, t);
            }
            break;

            case "Every Saturday": {
              widget.notif_weekly(Day.Saturday, t);
            }
            break;

            case "Every Sunday": {
              widget.notif_weekly(Day.Sunday, t);
            }
            break;
          }
        }
      });
    }
  }

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
            rowView(),
            Container(height: 20,),
            // Container(
            //   padding: EdgeInsets.only(left: 20),
            //   height: 50,
            //   decoration: BoxDecoration(color: Colors.purple[600], borderRadius: BorderRadius.all(Radius.circular(10))),
            //   child: rowView("Portfolio", "My Portfolio", 1.25),
            // ),
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

  Widget rowView(){
    if(weekly == 'None'){
      return Row( 
        children: <Widget>[
          Text("Repeat   ",
            textScaleFactor: 1.25,
            style: TextStyle(
              color: Colors.white         
            )
          ),
          DropdownButton<String>(
            value: weekly,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                weekly = newValue;
                _updateNotif();
              });
            },
            items: <String>['None', 'Every Day', 'Every Monday', 'Every Tuesday', 'Every Wednesday', 'Every Thursday', 'Every Friday', 'Every Saturday', 'Every Sunday']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      );
    }
    return Row( 
      children: <Widget>[
        Text("Repeat   ",
          textScaleFactor: 1.25,
          style: TextStyle(
            color: Colors.white         
          )
        ),
        DropdownButton<String>(
          value: weekly,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.white),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              weekly = newValue;
              _updateNotif();
            });
          },
          items: <String>['None', 'Every Day', 'Every Monday', 'Every Tuesday', 'Every Wednesday', 'Every Thursday', 'Every Friday', 'Every Saturday', 'Every Sunday']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Text("   at   ",
          textScaleFactor: 1.25,
          style: TextStyle(
            color: Colors.white         
          )
        ),
        DropdownButton<String>(
          value: time,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.white),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              time = newValue;
              _updateNotif();
            });
          },
          items: <String>['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
