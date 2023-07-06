import 'package:cloud_vault/providers/auth_status_provider.dart';
import 'package:cloud_vault/views/screens/auth/log_in.dart';
import 'package:cloud_vault/views/screens/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    var signInStatus = Provider.of<AuthStatusProvider>(context);
    return signInStatus.isSignIn ? const SignIn() : const SignUp();
  }
}
