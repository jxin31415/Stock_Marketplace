import 'package:flutter/material.dart';
import 'Goals.dart' as goal;
import 'Journal.dart' as journal;
import 'Home.dart' as home;
import 'Help.dart' as help;
import 'Settings.dart' as settings;
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 5, initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Marketplace',
      theme: ThemeData(
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
                new Tab(icon: new Icon(Icons.settings)),
                new Tab(icon: new Icon(Icons.help)),
              ]
           )
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            new goal.Goals(),
            new journal.Journal(),
            new home.Home(controller: _tabController),
            new settings.Settings(),
            new help.Help(),
          ]
        ) ,
      ),
    );
  }
}