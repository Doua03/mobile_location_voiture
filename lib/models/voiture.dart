class Voiture {
  final String id;
  final String marque;
  final String modele;
  final int annee;
  final String immat;
  final int places;
  final double prixJour;
  final double caution;
  bool estLouee;
  bool avecChauffeur;
  String? chauffeurId;

  Voiture({
    required this.id,
    required this.marque,
    required this.modele,
    required this.annee,
    required this.immat,
    required this.places,
    required this.prixJour,
    required this.caution,
    this.estLouee = false,
    this.avecChauffeur = false,
    this.chauffeurId,
  });

  factory Voiture.fromMap(Map<String, dynamic> map, String id) {
    return Voiture(
      id: id,
      marque: map['marque'] ?? '',
      modele: map['modele'] ?? '',
      annee: map['annee'] ?? 0,
      immat: map['immat'] ?? '',
      places: map['places'] ?? 0,
      prixJour: (map['prixJour'] ?? 0).toDouble(),
      caution: (map['caution'] ?? 0).toDouble(),
      estLouee: map['estLouee'] ?? false,
      avecChauffeur: map['avecChauffeur'] ?? false,
      chauffeurId: map['chauffeurId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'marque': marque,
    'modele': modele,
    'annee': annee,
    'immat': immat,
    'places': places,
    'prixJour': prixJour,
    'caution': caution,
    'estLouee': estLouee,
    'avecChauffeur': avecChauffeur,
    'chauffeurId': chauffeurId,
  };
}