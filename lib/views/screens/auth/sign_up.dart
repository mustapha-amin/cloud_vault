import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textfield_decoration.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/widgets/loading_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/auth_status_provider.dart';
import '../../../utils/reg_exprs.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late FocusNode focusNodeName;
  late FocusNode focusNodeEmail;
  ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);
  ValueNotifier<String?> fullNameErrorText = ValueNotifier<String?>(null);
  ValueNotifier<String?> emailErrorText = ValueNotifier<String?>(null);
  ValueNotifier<String?> passwordErrorText = ValueNotifier<String?>(null);
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    focusNodeName = FocusNode();
    focusNodeEmail = FocusNode();
    super.initState();
  }

  void toggleVisibility() {
    isVisible.value = !isVisible.value;
  }

  void displaynameError() {
    nameController.addListener(() {
      if (nameController.text.isEmpty) {
        fullNameErrorText.value = 'full name cannot be empty';
      } else {
        fullNameErrorText.value = null;
      }
    });
  }

  void displayEmailError() {
    emailController.addListener(() {
      if (emailController.text.isEmpty) {
        emailErrorText.value = 'email cannot be empty';
      }
      if (emailController.text.isNotEmpty) {
        if (!isValidEmail(emailController.text)) {
          emailErrorText.value = "email is not valid";
        }
        if (isValidEmail(emailController.text)) {
          emailErrorText.value = null;
        }
      }
    });
  }

  void displayPasswordError() {
    passwordController.addListener(() {
      if (passwordController.text.isEmpty) {
        passwordErrorText.value = 'password cannot be empty';
      }
      if (passwordController.text.isNotEmpty) {
        if (!isValidPassword(passwordController.text)) {
          passwordErrorText.value =
              'password must be 8 charcters long an must contain at least one letter and one digit';
        }
        if (isValidPassword(passwordController.text)) {
          passwordErrorText.value = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context);
    return provider.isLoading
        ? const LoadingWidget()
        : Scaffold(
            body: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          context.watch<ThemeProvider>().isDark
                              ? 'assets/images/auth-dark.png'
                              : 'assets/images/auth.png',
                          height: 30.h,
                        ),
                        Positioned(
                          top: 8,
                          child: Text(
                            "Sign Up",
                            style: kTextStyle(
                              context: context,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 30),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            ValueListenableBuilder(
                                valueListenable: fullNameErrorText,
                                builder: (_, value, __) {
                                  return TextFormField(
                                      focusNode: focusNodeName,
                                      textInputAction: TextInputAction.next,
                                      style: kTextStyle(
                                          context: context, size: 14),
                                      controller: nameController,
                                      decoration:
                                          defaultInputDecoration().copyWith(
                                        errorStyle: kTextStyle(
                                          context: context,
                                          size: 12,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        errorText: value,
                                        hintText: "Full name",
                                      ),
                                      onChanged: (_) =>
                                          displaynameError()).paddingAll(7);
                                }),
                            ValueListenableBuilder(
                                valueListenable: emailErrorText,
                                builder: (_, value, __) {
                                  return TextFormField(
                                    style:
                                        kTextStyle(context: context, size: 14),
                                    focusNode: focusNodeEmail,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    decoration:
                                        defaultInputDecoration().copyWith(
                                      hintText: "Email",
                                      errorText: value,
                                      errorStyle: kTextStyle(
                                        context: context,
                                        size: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    onChanged: (_) => displayEmailError(),
                                  ).paddingAll(7);
                                }),
                            ValueListenableBuilder(
                                valueListenable: passwordErrorText,
                                builder: (_, error, __) {
                                  return ValueListenableBuilder(
                                    valueListenable: isVisible,
                                    builder: (context, value, _) {
                                      return TextFormField(
                                        style: kTextStyle(
                                          context: context,
                                          size: 14,
                                        ),
                                        textInputAction: TextInputAction.done,
                                        controller: passwordController,
                                        obscureText: !value,
                                        decoration:
                                            defaultInputDecoration().copyWith(
                                          errorMaxLines: 2,
                                          hintText: "Password",
                                          errorText: error,
                                          errorStyle: kTextStyle(
                                            context: context,
                                            size: 12,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () => toggleVisibility(),
                                            child: Icon(
                                              value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                        onChanged: (_) =>
                                            displayPasswordError(),
                                      ).paddingAll(7);
                                    },
                                  );
                                }),
                            addVerticalSpacing(5),
                            SizedBox(
                              width: 100.w,
                              height: 9.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    provider.signUp(
                                      context,
                                      nameController.text,
                                      emailController.text.trim(),
                                      passwordController.text,
                                    );
                                  }
                                },
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
                                        context
                                            .read<AuthStatusProvider>()
                                            .toggleStatus();
                                      },
                                  ),
                                ],
                              ),
                            ).paddingAll(7),
                          ],
                        ),
                      ),
                    ),
                  ],
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
