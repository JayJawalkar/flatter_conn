// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models; // Import models
import 'package:flatter_conn/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

abstract class IAuthAPI {
  FutureEither<models.User> signUp({
    required String email,
    required String password,
    required String username,
  });
  FutureEither<models.Session> login({
    required String email,
    required String password,
  });
  Future<models.User?> currentUserAccount();
}

class AuthAPI implements IAuthAPI {
  final Account _account;

  AuthAPI({required Account account}) : _account = account;

  @override
  Future<models.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<models.User> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final user = await _account.create(
          userId: ID.unique(),
          email: email,
          password: password,
          name: username);
      return right(user);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? "UnExpected Error APPWRITE", stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<models.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return Left(
        Failure(e.message ?? "Unexpected Error in APPWRITE", stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
