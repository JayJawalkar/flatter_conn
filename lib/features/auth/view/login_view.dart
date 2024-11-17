import 'package:flatter_conn/common/loading_page.dart';
import 'package:flatter_conn/common/rounded_small_button.dart';
import 'package:flatter_conn/constants/constants.dart';
import 'package:flatter_conn/features/auth/controller/auth_controller.dart';
import 'package:flatter_conn/features/auth/view/signup_view.dart';
import 'package:flatter_conn/features/auth/widgets/auth_field.dart';
import 'package:flatter_conn/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogIn() {
    ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      AuthField(
                        controller: emailController,
                        hintText: "E-mail",
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthField(
                        controller: passwordController,
                        hintText: "Password",
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: RoundedSmallButton(
                          label: "Login",
                          onTap: onLogIn,
                          circularNess: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              text: " Sign Up",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Pallete.blueColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    SignupView.route(),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
