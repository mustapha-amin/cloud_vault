import 'package:cloud_vault/utils/textfield_decoration.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/auth_status_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  void toggleVisibility() {
    isVisible.value = !isVisible.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/auth.png',
                height: 30.h,
              ),
              Positioned(
                top: 8,
                child: Text(
                  "Sign Up",
                  style: kTextStyle(
                    context: context,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: defaultInputDecoration().copyWith(
                    hintText: "Full name",
                  ),
                ).paddingAll(7),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: defaultInputDecoration().copyWith(
                    hintText: "Email",
                  ),
                ).paddingAll(7),
                ValueListenableBuilder(
                  valueListenable: isVisible,
                  builder: (context, value, _) {
                    return TextFormField(
                      controller: passwordController,
                      obscureText: value,
                      decoration: defaultInputDecoration().copyWith(
                        hintText: "Password",
                        suffixIcon: GestureDetector(
                          onTap: () => toggleVisibility(),
                          child: Icon(
                              value ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                    ).paddingAll(7);
                  },
                ),
                SizedBox(
                  width: 100.w,
                  height: 9.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Sign up",
                      style: kTextStyle(
                        context: context,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ).paddingAll(7),
                RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    style: kTextStyle(context: context, size: 13),
                    children: [
                      TextSpan(
                        style: kTextStyle(
                            context: context,
                            size: 13,
                            color: Theme.of(context).primaryColor),
                        text: " Log In",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.read<AuthStatusProvider>().toggleStatus();
                          },
                      ),
                    ],
                  ),
                ).paddingAll(7),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on Widget {
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }
}
