class Event {
  final int id;
  final String titre;
  final String description;
  final double tarif;
  final String dateDebut;
  final String? dateFin;
  final String? horaire;
  final String image;
  final int categorieId;

  const Event(this.dateFin, this.horaire, {required this.id, required this.titre, required this.description, required this.tarif, required this.dateDebut, required this.image, required this.categorieId});

  factory Event.fromJson(Map<String, dynamic> json){
    return switch (json){
      {'id': int id, 'titre': String titre, 'description_md': String description, 'tarif': double tarif,
      'date_debut': String dateDebut, 'date_fin': String? dateFin, 'horaire': String? horaire, 'image': String image,
      'categorie_id': int categorieId} => Event(
          dateFin,
          horaire,
          id : id,
          titre : titre,
          description : description,
          tarif : tarif,
          dateDebut : dateDebut,
          image : image,
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