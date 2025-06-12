import 'package:chaudiere_mobile/screens/event_preview.dart';
import 'package:chaudiere_mobile/utils/api_utils.dart';
import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/models/event.dart';
import 'package:chaudiere_mobile/screens/event_search.dart';

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

  Future<void> searchedEvent(String mot) async{
    final events = await fetchEvents();
    final filtered = events.where((event) => event.titre.toLowerCase().contains(mot.toLowerCase())).toList();
    setState(() {
      futureEvent = Future.value(filtered);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaudière',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Liste des événements'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async{
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventSearch(),
                ),
              );
              if (result != null && result is String){
                searchedEvent(result);
              }
            }),
          ],
        ),
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
      ),
    );
  }
}