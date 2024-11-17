import 'package:flutter/material.dart';

import '../theme/theme.dart';

 class ErrorText extends StatelessWidget {
  final String errorText;
  const ErrorText({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorText,
        style: const TextStyle(
          color: Pallete.whiteColor,
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String errorText;
  const ErrorPage({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorText(errorText: errorText),
    );
  }
}
