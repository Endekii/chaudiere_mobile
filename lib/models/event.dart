class Event {
  final int id;
  final String titre;
  final String description;
  final String tarif;
  final DateTime dateDebut;
  final DateTime? dateFin;
  final DateTime? horaire;
  final String image;
  final int categorieId;

  const Event(this.dateFin, this.horaire, {required this.id, required this.titre, required this.description, required this.tarif, required this.dateDebut, required this.image, required this.categorieId});

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      json['date_fin'] != null ? DateTime.tryParse(json['date_fin']) : null,
      json['horaire'] != null ? DateTime.tryParse(json['horaire']) : null,
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description_md'] ?? '',
      tarif: json['tarif'] ?? '',
      dateDebut: DateTime.parse(json['date_debut']),
      image: json['image'] != null && json['image'] is Map<String, dynamic>
          ? (json['image']['href'] ?? '')
          : '',
      categorieId: json['categorie_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description_md': description,
      'tarif': tarif,
      'date_debut': dateDebut,
      'date_fin': dateFin,
      'horaire': horaire,
      'image': image,
      'categorie_id': categorieId,
    };
  }
}