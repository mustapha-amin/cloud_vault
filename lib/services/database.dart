import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_vault/models/user.dart';
import 'package:cloud_vault/utils/auth_constants.dart';

class DatabaseService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createUser(CloudVaultUser user) async {
    user.id = AuthConstants.userId;
    firebaseFirestore.collection('users').doc(user.id).set(user.toJson());
  }

  Stream<CloudVaultUser?> getUserInfo() {
    return firebaseFirestore
        .collection('users')
        .doc(AuthConstants.userId)
        .snapshots()
        .map((snap) => CloudVaultUser.fromFireStore(snap.data()!));
  }

  
}
