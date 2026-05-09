class Location {
  final String id;
  final String clientId;
  final String voitureId;
  final String? chauffeurId;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String priseVehicule;
  final String restitutionVehicule;
  final double prixTotal;

  Location({
    required this.id,
    required this.clientId,
    required this.voitureId,
    this.chauffeurId,
    required this.dateDebut,
    required this.dateFin,
    required this.priseVehicule,
    required this.restitutionVehicule,
    required this.prixTotal,
  });

  factory Location.fromMap(Map<String, dynamic> map, String id) {
    return Location(
      id: id,
      clientId: map['clientId'] ?? '',
      voitureId: map['voitureId'] ?? '',
      chauffeurId: map['chauffeurId'],
      dateDebut: (map['dateDebut'] as dynamic).toDate(),
      dateFin: (map['dateFin'] as dynamic).toDate(),
      priseVehicule: map['priseVehicule'] ?? '',
      restitutionVehicule: map['restitutionVehicule'] ?? '',
      prixTotal: (map['prixTotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'clientId': clientId,
    'voitureId': voitureId,
    'chauffeurId': chauffeurId,
    'dateDebut': dateDebut,
    'dateFin': dateFin,
    'priseVehicule': priseVehicule,
    'restitutionVehicule': restitutionVehicule,
    'prixTotal': prixTotal,
  };

  int get dureeJours => dateFin.difference(dateDebut).inDays;
}