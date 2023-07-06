import 'package:flutter/material.dart';

class AuthStatusProvider extends ChangeNotifier {
  bool isSignIn = true;

  void toggleStatus() {
    isSignIn = !isSignIn;
    notifyListeners();
  }
}
