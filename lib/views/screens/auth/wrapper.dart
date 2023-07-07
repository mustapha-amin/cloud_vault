import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:cloud_vault/views/screens/auth/authenticate.dart';
import 'package:cloud_vault/views/screens/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthConstants.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return const Home();
        } else {
          return const Authenticate();
        }
      },
    );
  }
}
