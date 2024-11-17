// ignore_for_file: file_names, deprecated_member_use

import 'package:flatter_conn/constants/assets_constants.dart';
import 'package:flatter_conn/features/explore/view/explore_view.dart';
import 'package:flatter_conn/features/tweet/widgets/tweet_list.dart';
import 'package:flatter_conn/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
    );
  }

  static const List<Widget> bottomTabBarPage = [
    TweetList(),
    ExploreView(),
    Text("Notification Tab"),
  ];
}
