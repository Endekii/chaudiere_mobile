import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchCategorieName(int id) async {
  final url = 'http://docketu.iutnc.univ-lorraine.fr:13000/api/categories/$id/';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['categories']?['libelle'] ?? 'Inconnu';
  } else {
    return 'Inconnu';
  }
}