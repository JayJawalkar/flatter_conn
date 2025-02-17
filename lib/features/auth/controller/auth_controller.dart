import 'package:flatter_conn/apis/auth_api.dart';
import 'package:flatter_conn/apis/user_api.dart';
import 'package:flatter_conn/core/core.dart';
import 'package:flatter_conn/features/auth/view/login_view.dart';
import 'package:flatter_conn/features/home/view/home_view.dart';
import 'package:flatter_conn/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as models; // Import models

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    return AuthController(
      authAPI: ref.watch(authAPIProvider),
      userAPI: ref.watch(userAPIProvider),
    );
  },
);

final currentUserDetailsProvider = FutureProvider((ref) async {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
  
});
final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});
final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserApi _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserApi userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<models.User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
      username: username,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      UserModel userModel = UserModel(
        email: email,
        name: username,
        followers: const [],
        following: const [],
        profilePic: '',
        bannerPic: '',
        uid: r.$id,
        bio: '',
        isTweeterBule: false,
      );
      final res2 = await _userAPI.savedUserData(userModel);
      res2.fold(
          (l) => {showSnackBar(context, l.message)},
          (r) => {
                showSnackBar(context, "Account Created! Please Login"),
                Navigator.push(
                  context,
                  LoginView.route(),
                )
              });
    });
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.push(
        context,
        HomeView.route(),
      );
      showSnackBar(context, "Login Sucess");
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(
      (document.data),
    );
    return updatedUser;
  }
}
