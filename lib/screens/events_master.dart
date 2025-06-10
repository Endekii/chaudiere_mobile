import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/models/event.dart';
import 'package:chaudiere_mobile/services/event_service.dart';

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
    futureEvent = EventService().fetchEvent();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Event>(
          future: futureEvent,
          builder: (context, snapshot){
            if(snapshot.hasData){

            } else {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
      ),
    );
  }
}