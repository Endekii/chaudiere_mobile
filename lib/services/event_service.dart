import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:chaudiere_mobile/models/event.dart';


class EventService {
  List<Event> _events = [];
  int lastId = 0;

  Future<List<Event>> getEvents() async{
    if(_events.isEmpty){
      await fetchEvent();
    }
    _events.sort((a, b) => a.id!.compareTo(b.id!));
    return _events;
  }

  Future<Event> fetchEvent() async{
    final response = await http.get(Uri.parse('http://docketu.iutnc.univ-lorraine.fr'));

    if (response.statusCode == 200){
      return Event.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load Event');
    }
  }
}