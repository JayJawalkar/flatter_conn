import 'package:flatter_conn/common/common.dart';
import 'package:flatter_conn/features/auth/controller/auth_controller.dart';
import 'package:flatter_conn/features/tweet/controller/tweet_controller.dart';
import 'package:flatter_conn/features/tweet/widgets/tweet_card.dart';
import 'package:flatter_conn/features/user_profile/controller/user_profile_controller.dart';
import 'package:flatter_conn/features/user_profile/widget/follow_count.dart';
import 'package:flatter_conn/models/tweet_model.dart';
import 'package:flatter_conn/models/user_model.dart';
import 'package:flatter_conn/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/appwrite_constants.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(user.bannerPic),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                            user.profilePic,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {},
                          child: Text(
                            currentUser.uid == user.uid
                                ? 'Edit Profile'
                                : 'Follow',
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          user.name,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FollowCount(
                              count: user.following.length,
                              text: 'Following',
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            FollowCount(
                              count: user.followers.length,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Divider(
                          color: Pallete.whiteColor,
                          thickness: 0.22,
                        )
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserTweetProvider(user.uid)).when(data: (tweets){
                  return ref.watch(getLatestTweetProvider).when(
                data: (data) {
                  final latestTweet=Tweet.fromMap(data.payload);
      
                  bool isTweetAlreadyPresent=false;
                  for(final tweetModel in tweets){
                    if (tweetModel.id==latestTweet.id) {
                      isTweetAlreadyPresent=true;
                      break;
                    }
                  }
      
                  if( !isTweetAlreadyPresent){
                     if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.create')) {
                    tweets.insert(
                      0,
                      Tweet.fromMap(data.payload),
                    );
                  }else if(data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.update')){
                        final startingPoint =data.events[0].lastIndexOf('documents.');
                        final endPoint=data.events[0].lastIndexOf('.update');
                        final tweetId=data.events[0].substring(startingPoint+10,endPoint);
                        
                        var tweet=tweets.where((element)=>element.id == tweetId).first;
                        
                        final tweetIndex=tweets.indexOf(tweet);
                        tweets.removeWhere((element)=>element.id==tweetId);
      
                        tweet=Tweet.fromMap(data.payload);
                        tweets.insert(tweetIndex, tweet);
      
                      }
                  }
                 
                  return Flexible(
                    child: ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  errorText: error.toString(),
                ),
                loading: () {
                  return Flexible(
                    child: ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    ),
                  );
                },
              );
            }, error: (error,st)=>ErrorText(errorText: error.toString()), loading: ()=>const Loader(),),
          );
  }
}
