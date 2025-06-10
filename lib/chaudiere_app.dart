import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/screens/events_master.dart';

class ChaudiereApp extends StatefulWidget {
  const ChaudiereApp({super.key});

  @override
  State<ChaudiereApp> createState() => _ChaudiereAppState();
}

class _ChaudiereAppState extends State<ChaudiereApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaudière',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chaudière'),
        ),
        body: EventsMaster(),
        ),
      );
  }
}