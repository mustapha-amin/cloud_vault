import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:cloud_vault/views/screens/auth/authenticate.dart';
import 'package:cloud_vault/views/screens/auth/verify_email.dart';
import 'package:cloud_vault/views/screens/home.dart';
import 'package:cloud_vault/views/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthConstants.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Home();
        } else if (!snapshot.hasData) {
          return const Authenticate();
        }
        return const LoadingWidget();
      },
    );
  }
}
