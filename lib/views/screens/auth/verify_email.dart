import 'dart:async';

import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:cloud_vault/utils/navigations.dart';
import 'package:cloud_vault/utils/textstyle.dart';
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
  ValueNotifier<bool> isEmailVerified = ValueNotifier<bool>(false);
  Timer? timer;

  Future checkEmailVerified(BuildContext context) async {
    await AuthConstants.user!.reload();

    isEmailVerified.value = AuthConstants.user!.emailVerified;

    if (isEmailVerified.value) {
      timer!.cancel();
      // ignore: use_build_context_synchronously
      navigateTo(context, const Home());
    }
  }

  @override
  void initState() {
    isEmailVerified.value = AuthConstants.user!.emailVerified;
    if (!isEmailVerified.value) {
      AuthConstants.user!.sendEmailVerification();
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        checkEmailVerified(context);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthConstants.user!.emailVerified
        ? const Home()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Verify email"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                      valueListenable: isEmailVerified,
                      builder: (_, value, __) {
                        return Text(
                          message,
                          style: kTextStyle(context: context, size: 13),
                        );
                      }),
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
                          message =
                              "A verification link has been sent to ${AuthConstants.user!.email}";
                        });
                      }).onError(
                        (error, stackTrace) => ScaffoldMessenger(
                          child: SnackBar(
                            content: Text('$error'),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size.fromHeight(50)),
                    label: Text(
                      "Resend email",
                      style: kTextStyle(
                        context: context,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
