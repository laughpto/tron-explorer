import 'package:explorer/ui/screens/dashboard.dart';
import 'package:flutter/material.dart';

import 'client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tron Blockchain Explorer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ConnectionStatusPage(),
    );
  }
}

class ConnectionStatusPage extends StatefulWidget {
  ConnectionStatusPage({Key? key}) : super(key: key);

  @override
  _ConnectionStatusPageState createState() => _ConnectionStatusPageState();
}

class _ConnectionStatusPageState extends State<ConnectionStatusPage> {
  bool connectionStatus = false;
  void _checkConnectionStatus() {
    client.checkConnectionStatus(context, (_connectionStatus) {
      setState(() {
        connectionStatus = _connectionStatus;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: connectionStatus ? Dashboard() : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No connection',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
