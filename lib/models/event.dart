class Event {
  final int id;
  final String titre;
  final String description;
  final double tarif;
  final String dateDebut;
  final String dateFin;
  final String horaire;
  final bool publie;
  final String image;
  final int categorieId;
  final String creePar;
  final String dateCreation;

  const Event({required this.id, required this.titre, required this.description, required this.tarif, required this.dateDebut,
    required this.dateFin, required this.horaire, required this.publie, required this.image, required this.categorieId, required this.creePar,
    required this.dateCreation});

  factory Event.fromJson(Map<String, dynamic> json){
    return switch (json){
      {'id': int id, 'titre': String titre, 'description_md': String description, 'tarif': double tarif,
      'date_debut': String dateDebut, 'date_fin': String dateFin, 'horaire': String horaire, 'publie': bool publie, 'image': String image,
      'categorie_id': int categorieId, 'cree_par': String creePar, 'date_creation': String dateCreation} => Event(
        id : id,
        titre : titre,
        description : description,
        tarif : tarif,
        dateDebut : dateDebut,
        dateFin : dateFin,
        horaire : horaire,
        publie : publie,
        image : image,
        categorieId : categorieId,
        creePar : creePar,
        dateCreation : dateCreation,
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
      'publie': publie ? 1 : 0,
      'image': image,
      'categorie_id': categorieId,
      'cree_par': creePar,
      'date_creation': dateCreation,
    };
  }
}