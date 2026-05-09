import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;
  String? _role;
  String? get role => _role;

  AuthProvider() {
    _auth.authStateChanges().listen((u) async {
      if (u != null) await _loadRole(u.uid);
      notifyListeners();
    });
  }

  Future<void> _loadRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    _role = doc.data()?['role'] ?? 'client';
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password, String nom, String role) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);
    await _db.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'nom': nom,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final cred = await _auth.signInWithCredential(credential);
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    if (!doc.exists) {
      await _db.collection('users').doc(cred.user!.uid).set({
        'email': cred.user!.email,
        'nom': cred.user!.displayName,
        'role': 'client',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _role = null;
    notifyListeners();
  }
}