import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:flutter/material.dart';

import '../../../utils/auth_constants.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mark_email_unread,
              size: 40,
            ),
            addVerticalSpacing(20),
            Text(
              "we've sent email to ${AuthConstants.user!.email} to verify your email addess. Tap the link to activate your account",
              style: kTextStyle(context: context, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
