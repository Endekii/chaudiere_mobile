import 'package:flutter/material.dart';
import 'evenement.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class EvenementProvider extends ChangeNotifier {
  List<Evenement> _evenements = [];

  Future<List<Evenement>> get evenements => Future.value(_evenements);

  void fetchEvenements() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = await openDatabase(
      join(await getDatabasesPath(), 'evenements.db'),
    );
    final response = await http.get(
      Uri.parse('http://localhost:13000/api/evenements'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = response.body as List<dynamic>;
      _evenements = jsonResponse.map((e) => Evenement.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load evenements');
    }
    _evenements;
    notifyListeners();
  }



  void initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = await openDatabase(
      join(await getDatabasesPath(), 'evenements.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE evenements(id INTEGER PRIMARY KEY, titre TEXT, description_md TEXT, tarif REAL, date_debut TEXT, date_fin TEXT, horaire TEXT, publie INTEGER, image TEXT, categorie_id INTEGER, cree_par TEXT, date_creation TEXT)',
        );
      },
      version: 1,
    );
  }

}