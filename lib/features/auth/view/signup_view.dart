import 'package:flatter_conn/constants/constants.dart';
import 'package:flatter_conn/features/auth/controller/auth_controller.dart';
import 'package:flatter_conn/features/auth/view/login_view.dart';
import 'package:flatter_conn/features/auth/widgets/auth_field.dart';
import 'package:flatter_conn/theme/pallete.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flatter_conn/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignupView(),
      );
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AuthField(
                        controller: usernameController,
                        hintText: "Username",
                      ),
                      const SizedBox(
                        height: 30,
                      ),
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
                          label: "Sign-up",
                          onTap: onSignUp, circularNess: 15,
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
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: " Login",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Pallete.blueColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    LoginView.route(),
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
