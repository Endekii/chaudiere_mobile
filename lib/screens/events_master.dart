import 'dart:convert';

import 'package:chaudiere_mobile/screens/event_preview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chaudiere_mobile/models/event.dart';

Future<List<Event>> fetchEvent() async {
  final response = await http.get(
    Uri.parse('http://docketu.iutnc.univ-lorraine.fr:13000/api/evenements/'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> eventsJson = data['evenement'];
    return eventsJson.map((json) => Event.fromJson(json)).toList();
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
  late Future<List<Event>> futureEvent;

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
          child: FutureBuilder<List<Event>>(
            future: futureEvent,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return EventPreview(event: events[index]);
                  },
                );
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