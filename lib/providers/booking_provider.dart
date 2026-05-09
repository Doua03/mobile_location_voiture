import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/location.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Location> _locations = [];
  List<Location> get locations => _locations;

  BookingProvider() {
    _db.collection('locations').snapshots().listen((snapshot) {
      _locations = snapshot.docs
          .map((d) => Location.fromMap(d.data(), d.id))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addLocation(Location loc) async {
    await _db.collection('locations').add(loc.toMap());
    await _db.collection('voitures').doc(loc.voitureId).update({
      'estLouee': true,
      'chauffeurId': loc.chauffeurId,
      'avecChauffeur': loc.chauffeurId != null,
    });
  }

  Future<void> deleteLocation(Location loc) async {
    await _db.collection('locations').doc(loc.id).delete();
    await _db.collection('voitures').doc(loc.voitureId).update({
      'estLouee': false,
      'chauffeurId': null,
      'avecChauffeur': false,
    });
  }

  List<Location> getLocationsParClient(String clientId) =>
      _locations.where((l) => l.clientId == clientId).toList();

  List<Location> getLocationsDuMois() {
    final now = DateTime.now();
    return _locations.where((l) =>
      l.dateDebut.month == now.month && l.dateDebut.year == now.year
    ).toList();
  }

  double getRevenuDuMois() =>
      getLocationsDuMois().fold(0, (sum, l) => sum + l.prixTotal);
}