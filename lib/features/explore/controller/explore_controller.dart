import 'package:flatter_conn/apis/user_api.dart';
import 'package:flatter_conn/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(
    userApi: ref.watch(userAPIProvider),
  );
});

final searchUserProvider = FutureProvider.family((ref,String name) async {
  final exploreController= ref.watch(exploreControllerProvider.notifier);
  return  exploreController.searchUser(name);
});
class ExploreController extends StateNotifier<bool> {
  final UserApi _userApi;
  ExploreController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userApi.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
