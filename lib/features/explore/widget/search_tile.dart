import 'package:flatter_conn/features/user_profile/view/user_profile_view.dart';
import 'package:flatter_conn/models/user_model.dart';
import 'package:flatter_conn/theme/pallete.dart';
import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          UserProfileView.route(
            userModel,
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModel.profilePic),
        radius: 25,
      ),
      title: Text(
        userModel.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: const TextStyle(
              fontSize: 16,
              color: Pallete.greyColor,
            ),
          ),
          Text(
            userModel.bio,
            style: const TextStyle(
              fontSize: 16,
              color: Pallete.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
