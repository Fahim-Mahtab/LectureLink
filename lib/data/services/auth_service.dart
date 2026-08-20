import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> get authStateChanges =>
      _auth?.authStateChanges() ?? const Stream.empty();

  User? get currentUser => _auth?.currentUser;

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth != null) {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    return null;
  }

  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    final auth = _auth;
    if (auth != null) {
      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (name != null && name.trim().isNotEmpty) {
        await cred.user?.updateDisplayName(name.trim());
      }
      return cred;
    }
    return null;
  }

  Future<void> updateDisplayName(String name) async {
    final user = currentUser;
    if (user != null) {
      await user.updateDisplayName(name.trim());
      await user.reload();
    }
  }

  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
    }
  }
}
