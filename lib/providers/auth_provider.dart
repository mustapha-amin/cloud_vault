import 'package:cloud_vault/models/user.dart';
import 'package:cloud_vault/services/database.dart';
import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:cloud_vault/utils/navigations.dart';
import 'package:cloud_vault/views/screens/auth/verify_email.dart';
import 'package:cloud_vault/views/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../views/widgets/error_dialog.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth? firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  String? error;

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> signIn(
    BuildContext context,
    String? email,
    String? password,
  ) async {
    try {
      toggleLoading();
      await firebaseAuth!.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // ignore: use_build_context_synchronously
      navigateTo(context, const Home());
    } on FirebaseException catch (e) {
      toggleLoading();
      if (e.code == 'user-not-found') {
        error = "User not found";
        showErrorDialog(context, error);
      } else if (e.code == "wrong-password") {
        error = "Incorrect password";
        showErrorDialog(context, error);
      } else if (e.code == "network-request-failed") {
        error = "A network error occured, check your internet settings";
        showErrorDialog(context, error);
      } else {
        showErrorDialog(context, "An error occured");
      }
    }
  }

  Future<void> signUp(
    BuildContext context,
    String? name,
    String? email,
    String? password,
  ) async {
    try {
      toggleLoading();
      await firebaseAuth!.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      DatabaseService().createUser(CloudVaultUser(
        name: name,
        email: email,
      ));
      await AuthConstants.user!.updateDisplayName(name);
      await AuthConstants.user!.updateEmail(email);
     // toggleLoading();
      // ignore: use_build_context_synchronously
      navigateTo(context, const VerifyEmail());
    } on FirebaseException catch (e) {
      toggleLoading();
      if (e.code == 'user-not-found') {
        error = "User not found";
      } else if (e.code == "wrong-password") {
        error = "Incorrect password";
      } else if (e.code == "network-request-failed") {
        error = "A network occured, check your internet settings";
      } else {
        error = e.message.toString();
      }
      showErrorDialog(context, error);
    }
  }

  Future<void> signOut() async {
    await firebaseAuth!.signOut();
  }

  Future<void> sendEmailVerification() async {
    AuthConstants.user!.sendEmailVerification();
  }
}
