class Chauffeur {
  final String id;
  final String nom;
  final String prenom;
  final String telephone;
  final String permis;
  String? voitureId;

  Chauffeur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.permis,
    this.voitureId,
  });

  factory Chauffeur.fromMap(Map<String, dynamic> map, String id) {
    return Chauffeur(
      id: id,
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      telephone: map['telephone'] ?? '',
      permis: map['permis'] ?? '',
      voitureId: map['voitureId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'permis': permis,
    'voitureId': voitureId,
  };
}