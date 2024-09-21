import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _loadUserFromPreferences();
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _saveUserToPreferences();
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  void signOut() async {
    await _firebaseAuth.signOut();
    _removeUserFromPreferences();
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  /// Save user session in shared preferences
  Future<void> _saveUserToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      prefs.setString('userId', _user!.uid);
    }
  }

  /// Remove user session from shared preferences on sign out
  Future<void> _removeUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  /// Load user session from shared preferences
  Future<void> _loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      // Automatically re-authenticate the user if they are still logged in.
      _user = _firebaseAuth.currentUser;
    }
  }
}
