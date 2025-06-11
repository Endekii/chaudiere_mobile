import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chaudiere_mobile/models/event.dart';

final url = 'http://docketu.iutnc.univ-lorraine.fr:13000/api/';

Future<String> fetchCategorieName(int id) async {
  final response = await http.get(Uri.parse('${url}categories/$id/'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['categories']?['libelle'] ?? 'Inconnu';
  } else {
    return 'Inconnu';
  }
}

Future<Event> fetchEvent(int id) async {
  final response = await http.get(Uri.parse('${url}evenements/$id/'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Event.fromJson(data['evenement']);
  } else {
    throw Exception('Failed to load event');
  }
}