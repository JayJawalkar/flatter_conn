import 'package:flatter_conn/common/common.dart';
import 'package:flatter_conn/features/explore/controller/explore_controller.dart';
import 'package:flatter_conn/features/explore/widget/search_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  bool isShowUsers = true;
  final searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: SearchBar(
            onSubmitted: (value){
              setState(() {
                isShowUsers=true;
              });
            },
            controller: searchController,
            hintText: 'Search to Conn',
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
              data: (users) {
                return ListView.builder(
                    itemCount:users.length,
                    itemBuilder: (BuildContext context, int index) {
                  final user = users[index];
                  return SearchTile(userModel: user);
                });
              },
              error: (error, stackTrace) => ErrorText(
                    errorText: error.toString(),
                  ),
              loading: () => const Loader())
          : const SizedBox(),
    );
  }
}
