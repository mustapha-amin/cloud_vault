import 'dart:async';

import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:flutter/material.dart';

import '../../../utils/spacings.dart';
import '../home.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  var message = "A verification email has been sent";
  bool isEmailVerified = false;
  Timer? timer;

  Future checkEmailVerified() async {
    await AuthConstants.user!.reload();
    setState(() {
      isEmailVerified = AuthConstants.user!.emailVerified;
    });
    if (isEmailVerified) {
      timer!.cancel();
    }
  }

  @override
  void initState() {
    isEmailVerified = AuthConstants.user!.emailVerified;
    if (!isEmailVerified) {
      AuthConstants.user!.sendEmailVerification();
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        checkEmailVerified();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const Home()
        : Scaffold(
            backgroundColor: Colors.grey[800],
            appBar: AppBar(
              title: const Text("verify email"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, style: const TextStyle(color: Colors.white)),
                  addVerticalSpacing(20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        message = "Waiting for response...";
                      });
                      await AuthConstants.user!
                          .sendEmailVerification()
                          .whenComplete(() {
                        setState(() {
                          message = "A verification email has been sent";
                        });
                      }).onError((error, stackTrace) => ScaffoldMessenger(
                              child: SnackBar(content: Text('$error'))));
                    },
                    icon: const Icon(Icons.email),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    label: const Text("Resend email"),
                  ),
                ],
              ),
            ),
          );
  }
}
