import 'package:flutter/material.dart';
import 'Goals.dart' as goal;
import 'Journal.dart' as journal;
import 'Home.dart' as home;
import 'Watchlist.dart' as watchlist;
import 'Settings.dart' as settings;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {

  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController _tabController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 5, initialIndex: 2);

    var initializationSettingsAndroid = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if(payload != null){
      debugPrint('notification payload: ' + payload);
    }
  }

  Future _weeklyNotif(Day day, int hour) async {
    await _cancel();

    var time = Time(hour, 0, 0);
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('show weekly channel id',
            'show weekly channel name', 'show weekly description');
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'weekly notification title',
        'Weekly notification description',
        day,
        time,
        platformChannelSpecifics);
  }

  Future _dailyNotif(int hour) async {
    await _cancel();

    var time = Time(hour, 0, 0);

    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'daily notification title',
        'daily notification description',
        time,
        platformChannelSpecifics);
  }

  Future<int> _cancel() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    return 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Stock Marketplace',
        theme: ThemeData(
          canvasColor: Colors.blue[900],
        ),
        home: Scaffold(
            backgroundColor: Colors.black,
            bottomNavigationBar: new Material(
              color: Colors.deepPurple[900],
              child: new TabBar(
                controller: _tabController,
                tabs: <Tab> [
                  new Tab(icon: new Icon(Icons.track_changes)),
                  new Tab(icon: new Icon(Icons.book)),
                  new Tab(icon: new Icon(Icons.home)),
                  new Tab(icon: new Icon(Icons.bookmark_border)),
                  new Tab(icon: new Icon(Icons.settings)),
                ]
            )
          ),
          body: new TabBarView(
            controller: _tabController,
            children: <Widget>[
              new goal.Goals(),
              new journal.Journal(),
              new home.Home(controller: _tabController),
              new watchlist.Watchlist(location: 1),
              new settings.Settings(notif_daily: _dailyNotif, notif_weekly: _weeklyNotif, cancel_notif: _cancel,),
            ]
          ) ,
        ),
      ),
    );
  }
}