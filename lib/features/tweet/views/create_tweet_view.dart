import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flatter_conn/common/common.dart';
import 'package:flatter_conn/constants/assets_constants.dart';
import 'package:flatter_conn/core/core.dart';
import 'package:flatter_conn/features/auth/controller/auth_controller.dart';
import 'package:flatter_conn/features/tweet/controller/tweet_controller.dart';
import 'package:flatter_conn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateTweetView(),
      );
  const CreateTweetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetViewState();
}

class _CreateTweetViewState extends ConsumerState<CreateTweetView> {
  final tweetTextEditingController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    tweetTextEditingController.dispose();
    super.dispose();
  }

  void pickImages() async {
    images = await pickImage();
    setState(() {});
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: tweetTextEditingController.text,
          context: context,
          repliedTo: '',
        );
    showSnackBar(context, '👀 Connnected');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: RoundedSmallButton(
              onTap: shareTweet,
              label: "Tweet",
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
              circularNess: 35,
            ),
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(currentUser.profilePic),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: tweetTextEditingController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                              hintText: " What's Happening ?",
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty) // Add condition for images
                      CarouselSlider(
                        items: images.map((file) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Image.file(file),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: pickImages,
                child: SvgPicture.asset(
                  AssetsConstants.galleryIcon,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
