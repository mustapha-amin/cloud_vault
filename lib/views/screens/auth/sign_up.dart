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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 30),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              focusNode: focusNodeName,
                              textInputAction: TextInputAction.next,
                              controller: nameController,
                              decoration: defaultInputDecoration().copyWith(
                                hintText: "Full name",
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? "enter your name" : null,
                            ).paddingAll(7),
                            TextFormField(
                              focusNode: focusNodeEmail,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: defaultInputDecoration().copyWith(
                                hintText: "Email",
                              ),
                              validator: (val) => emailController.text.isEmpty
                                  ? 'enter your email'
                                  : isValidEmail(val!)
                                      ? null
                                      : 'invalid email',
                            ).paddingAll(7),
                            ValueListenableBuilder(
                              valueListenable: isVisible,
                              builder: (context, value, _) {
                                return TextFormField(
                                  textInputAction: TextInputAction.done,
                                  controller: passwordController,
                                  obscureText: !value,
                                  decoration: defaultInputDecoration().copyWith(
                                    errorMaxLines: 2,
                                    hintText: "Password",
                                    suffixIcon: GestureDetector(
                                      onTap: () => toggleVisibility(),
                                      child: Icon(
                                        value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                  validator: (val) => passwordController
                                          .text.isEmpty
                                      ? 'enter your password'
                                      : isValidPassword(val!)
                                          ? null
                                          : 'password must be 8 charcters long an must contain at least one letter and one digit',
                                ).paddingAll(7);
                              },
                            ),
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
