// ignore_for_file: deprecated_member_use

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flatter_conn/common/common.dart';
import 'package:flatter_conn/constants/assets_constants.dart';
import 'package:flatter_conn/core/core.dart';
import 'package:flatter_conn/features/auth/controller/auth_controller.dart';
import 'package:flatter_conn/features/tweet/controller/tweet_controller.dart';
import 'package:flatter_conn/features/tweet/views/twitter_reply_view.dart';
import 'package:flatter_conn/features/tweet/widgets/carousel_images.dart';
import 'package:flatter_conn/features/tweet/widgets/hashtag_text.dart';
import 'package:flatter_conn/features/tweet/widgets/tweet_icon_button.dart';
import 'package:flatter_conn/models/tweet_model.dart';
import 'package:flatter_conn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      TwitterReplyView.route(tweet),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                user.profilePic,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //retweeted
                                if (tweet.retweetedBy.isNotEmpty)
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AssetsConstants.retweetIcon,
                                        color: Pallete.greyColor,
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text('${tweet.retweetedBy} reConn'),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        right: 5,
                                      ),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '@${user.name} · ${timeago.format(
                                        tweet.createdAt,
                                        locale: 'en_short',
                                      )}',
                                      style: const TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                //replied to
                                if (tweet.repliedTo.isNotEmpty)
                                  ref
                                      .watch(
                                          getTweetByIdProvider(tweet.repliedTo))
                                      .when(
                                          data: (repliedToTweet) {
                                            final replyingToUser = ref
                                                .watch(userDetailsProvider(
                                                    repliedToTweet.uid))
                                                .value;
                                            return RichText(
                                              text: TextSpan(
                                                  text: 'Replying to',
                                                  style: const TextStyle(
                                                    color: Pallete.greyColor,
                                                    fontSize: 16,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          ' @${replyingToUser?.name}',
                                                      style: const TextStyle(
                                                        color:
                                                            Pallete.blueColor,
                                                        fontSize: 16,
                                                      ),
                                                    )
                                                  ]),
                                            );
                                          },
                                          error: (error, st) => ErrorText(
                                                errorText: error.toString(),
                                              ),
                                          loading: () => const SizedBox()),

                                HashtagText(text: tweet.text),
                                if (tweet.tweetType == TweetType.image)
                                  CarouselImages(imageLinks: tweet.imageLinks),
                                if (tweet.link.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  AnyLinkPreview(
                                    link: 'https://${tweet.link}',
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                  ),
                                ],
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    right: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TweetIconButton(
                                        pathName: AssetsConstants.viewsIcon,
                                        text: (
                                          tweet.commentIds.length +
                                              tweet.reshareCount +
                                              tweet.likes.length,
                                        ).toString(),
                                        onTap: () {},
                                      ),
                                      TweetIconButton(
                                        pathName: AssetsConstants.commentIcon,
                                        text:
                                            tweet.commentIds.length.toString(),
                                        onTap: () {},
                                      ),
                                      TweetIconButton(
                                        pathName: AssetsConstants.retweetIcon,
                                        text: tweet.reshareCount.toString(),
                                        onTap: () {
                                          ref
                                              .read(tweetControllerProvider
                                                  .notifier)
                                              .reshareTweet(
                                                  tweet, currentUser, context);
                                        },
                                      ),
                                      LikeButton(
                                        onTap: (isLiked) async {
                                          ref
                                              .read(tweetControllerProvider
                                                  .notifier)
                                              .likeTweet(tweet, currentUser);
                                          return !isLiked;
                                        },
                                        isLiked: tweet.likes
                                            .contains(currentUser.uid),
                                        size: 25,
                                        likeBuilder: (isLiked) {
                                          return isLiked
                                              ? SvgPicture.asset(
                                                  AssetsConstants
                                                      .likeFilledIcon,
                                                  color: Pallete.redColor,
                                                )
                                              : SvgPicture.asset(
                                                  AssetsConstants
                                                      .likeOutlinedIcon,
                                                  color: Pallete.greyColor,
                                                );
                                        },
                                        likeCount: tweet.likes.length,
                                        countBuilder:
                                            (likeCount, isLiked, text) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: Text(
                                              text,
                                              style: const TextStyle(
                                                  fontSize: 16.5),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.share_outlined,
                                          size: 25,
                                          color: Pallete.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 1,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        color: Pallete.backgroundColor,
                      )
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                errorText: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}
