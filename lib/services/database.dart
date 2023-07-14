import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:cloud_vault/models/user.dart';
import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:cloud_vault/utils/extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

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

  Future<void> uploadFile(
      BuildContext context, PlatformFile file, String? fileType) async {
    try {
      final path = '${AuthConstants.userId}/${fileType}s/${file.name}';
      final ref = firebaseStorage.ref().child(path);
      await ref.putFile(File(file.path!));
      // ignore: use_build_context_synchronously
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Uploaded successfully"),
        margin: EdgeInsets.all(6),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<List<Reference>> getFiles(String? fileType) async {
    final path = '/${AuthConstants.userId}/$fileType';
    log(path);
    ListResult result = await firebaseStorage.ref(path).listAll();
    return result.items;
  }

  Future<void> deleteFile(String? fileType, String? fileName) async {
    final path = '/${AuthConstants.userId}/$fileType/$fileName';
    await firebaseStorage.ref(path).delete();
  }
}
