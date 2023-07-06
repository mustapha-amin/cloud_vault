import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Uploading.gif',
            width: 80.w,
            height: 30.h,
            colorBlendMode: BlendMode.color,
          ),
          addVerticalSpacing(20.h),
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
          addVerticalSpacing(10.h),
          SizedBox(
            width: 90.w,
            height: 8.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
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
        ],
      ),
    );
  }
}
