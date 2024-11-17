import 'package:flatter_conn/common/common.dart';
import 'package:flatter_conn/features/auth/controller/auth_controller.dart';
import 'package:flatter_conn/features/auth/view/signup_view.dart';
import 'package:flatter_conn/features/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flatter Conn',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
              return const SignupView();
            },
            error: (error, st) => ErrorPage(
              errorText: error.toString(),
            ),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
