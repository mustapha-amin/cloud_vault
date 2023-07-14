import 'package:cloud_vault/services/onboarding_pref.dart';
import 'package:cloud_vault/utils/navigations.dart';
import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/screens/auth/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addVerticalSpacing(30.h),
          Image.asset(
            'assets/images/Uploading.gif',
            width: 80.w,
            height: 30.h,
            colorBlendMode: BlendMode.color,
          ),
          addVerticalSpacing(4.h),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Welcome to cloud vault",
                style: kTextStyle(
                    context: context, size: 20, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "\n\nYour files, within reach",
                    style: kTextStyle(context: context, size: 15),
                  )
                ],
              ),
            ),
          ),
          addVerticalSpacing(8.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 90.w,
              height: 8.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  replaceScreen(context, const Authenticate());
                  OnboardingPreference.savePref(false);
                },
                child: Text(
                  "Get started",
                  style: kTextStyle(
                    context: context,
                    size: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
