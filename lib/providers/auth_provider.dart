import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isSignIn = true;

  void toggleStatus() {
    isSignIn = !isSignIn;
    notifyListeners();
  }
}
