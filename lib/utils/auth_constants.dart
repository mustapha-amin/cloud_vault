import 'package:firebase_auth/firebase_auth.dart';

class AuthConstants {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static User? get user => _firebaseAuth.currentUser;
  static Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  static String? get userId => _firebaseAuth.currentUser!.uid;
  
}
