import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chaudiere_mobile/models/event.dart';

Future<Event> fetchEvent() async {
  final response = await http.get(
    Uri.parse('http://docketu.iutnc.univ-lorraine.fr:13000/api/evenements/1'),
  );

  if (response.statusCode == 200) {
    print(response.body);
    return Event.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load event');
  }
}

class EventsMaster extends StatefulWidget {
  const EventsMaster({super.key});

  @override
  State<EventsMaster> createState() => _EventsMasterState();
}

class _EventsMasterState extends State<EventsMaster> {
  late Future<Event> futureEvent;

  @override
  void initState(){
    super.initState();
    futureEvent = fetchEvent();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaudière',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Liste des événements')),
        body: Center(
          child: FutureBuilder<Event>(
            future: futureEvent,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.titre);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}