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
    return switch (json){
      {'id': int id, 'titre': String titre, 'description_md': String description, 'tarif': String tarif,
      'date_debut': String dateDebut, 'date_fin': String? dateFin, 'horaire': String? horaire, 'image': Map<String, dynamic> image,
      'categorie_id': int categorieId} => Event(
          dateFin != null ? DateTime.parse(dateFin) : null,
          horaire != null ? DateTime.parse(horaire) : null,
          id : id,
          titre : titre,
          description : description,
          tarif : tarif,
          dateDebut : DateTime.parse(dateDebut),
          image : image['href'] ?? '',
          categorieId : categorieId
      ),
      _ => throw const FormatException('Failed to load Event'),
    };
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