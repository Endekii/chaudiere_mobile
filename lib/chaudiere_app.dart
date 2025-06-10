import 'package:chaudiere_mobile/screens/events_master.dart';
import 'package:flutter/material.dart';

class ChaudiereApp extends StatefulWidget {
  const ChaudiereApp({Key? key}) : super(key: key);
  @override
  _ChaudiereAppState createState() => _ChaudiereAppState();
}

class _ChaudiereAppState extends State<ChaudiereApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaudiere Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chaudiere Mobile'),
        ),
        body: EventsMaster(),
      ),
    );
  }
}