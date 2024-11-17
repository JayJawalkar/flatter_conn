import 'package:flatter_conn/common/common.dart';
import 'package:flatter_conn/features/tweet/controller/tweet_controller.dart';
import 'package:flatter_conn/features/tweet/widgets/tweet_card.dart';
import 'package:flatter_conn/models/tweet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/appwrite_constants.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetProvider).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
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
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    errorText: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorText(
            errorText: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
