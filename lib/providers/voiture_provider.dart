import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/voiture.dart';

class VoitureProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Voiture> _voitures = [];
  List<Voiture> get voitures => _voitures;

  VoitureProvider() {
    _db.collection('voitures').snapshots().listen((snapshot) {
      _voitures = snapshot.docs
          .map((d) => Voiture.fromMap(d.data(), d.id))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addVoiture(Voiture v) async {
    await _db.collection('voitures').add(v.toMap());
  }

  Future<void> updateVoiture(Voiture v) async {
    await _db.collection('voitures').doc(v.id).update(v.toMap());
  }

  Future<void> deleteVoiture(String id) async {
    await _db.collection('voitures').doc(id).delete();
  }

  List<Voiture> get voituresLibres =>
      _voitures.where((v) => !v.estLouee).toList();

  List<Voiture> get voituresLouees =>
      _voitures.where((v) => v.estLouee).toList();
}