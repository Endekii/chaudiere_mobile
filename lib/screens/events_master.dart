import 'package:chaudiere_mobile/screens/event_preview.dart';
import 'package:chaudiere_mobile/utils/api_utils.dart';
import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/models/event.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeProvider.dart';

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
    futureEvent = fetchEvents();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}