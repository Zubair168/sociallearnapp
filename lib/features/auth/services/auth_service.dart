import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ─── Email / Password Register ───────────────────────────────────────────────
  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_friendlyError(e.code));
      return false;
    }
  }

  // ─── Email / Password Login ───────────────────────────────────────────────
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_friendlyError(e.code));
      return false;
    }
  }

  // ─── Google Sign-In ──────────────────────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false; // User cancelled
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_friendlyError(e.code));
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('Google sign-in failed. Please add SHA-1 to Firebase console.');
      return false;
    }
  }

  // ─── Password Reset ──────────────────────────────────────────────────────
  Future<bool> sendPasswordReset({required String email}) async {
    try {
      _setLoading(true);
      _setError(null);
      await _auth.sendPasswordResetEmail(email: email.trim());
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(_friendlyError(e.code));
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to send reset email. Please try again.');
      return false;
    }
  }

  // ─── Sign Out ────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  // ─── Error Messages ──────────────────────────────────────────────────────
  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
