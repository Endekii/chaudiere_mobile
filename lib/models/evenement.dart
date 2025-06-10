import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Evenement {
  final int id;
  final String titre;
  final String description_md;
  final Float tarif;
  final String date_debut;
  String? date_fin;
  final String horaire;
  final bool publie;
  final String image;
  final int categorie_id;
  final String cree_par;
  final String date_creation;

  Evenement({
    required this.id,
    required this.titre,
    required this.description_md,
    required this.tarif,
    required this.date_debut,
    this.date_fin,
    required this.horaire,
    required this.publie,
    required this.image,
    required this.categorie_id,
    required this.cree_par,
    required this.date_creation,
  });

  factory Evenement.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      Map<String, dynamic> data when data.containsKey('id') => Evenement(
        id: data['id'],
        titre: data['titre'],
        description_md: data['description_md'],
        tarif: data['tarif'].toDouble(),
        date_debut: data['date_debut'],
        date_fin: data['date_fin'],
        horaire: data['horaire'],
        publie: data['publie'] == 1,
        image: data['image'],
        categorie_id: data['categorie_id'],
        cree_par: data['cree_par'],
        date_creation: data['date_creation'],
      ),
      _ => throw const FormatException('Invalid JSON format for Evenement'),
    };
  }

  Future<Evenement> fetchEvenement(int id) async {
    final response = await http.get(
      Uri.parse('http://localhost:13000/api/evenements/$id'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = response.body as List<dynamic>;
      return Evenement.fromJson(jsonResponse[0] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load evenements');
    }
  }
  
  @override
  String toString() {
    return 'Evenement{id: $id, titre: $titre, description_md: $description_md, tarif: $tarif, date_debut: $date_debut, date_fin: $date_fin, horaire: $horaire, publie: $publie, image: $image, categorie_id: $categorie_id, cree_par: $cree_par, date_creation: $date_creation}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description_md': description_md,
      'tarif': tarif,
      'date_debut': date_debut,
      'date_fin': date_fin,
      'horaire': horaire,
      'publie': publie ? 1 : 0,
      'image': image,
      'categorie_id': categorie_id,
      'cree_par': cree_par,
      'date_creation': date_creation,
    };
  }

  Future<void> insertEvenement(Evenement evenement) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'evenements.db'),
    );
    await database.insert(
      'evenements',
      evenement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
