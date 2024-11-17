import 'package:flatter_conn/apis/tweet_api.dart';
import 'package:flatter_conn/models/tweet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileControllerProvider = StateNotifierProvider((ref) {
  return UserProfileController(tweetApi: ref.watch(tweetAPIProvider));
});
final getUserTweetProvider = FutureProvider.family((ref,String uid)async {
  final userProfileController=ref.watch(userProfileControllerProvider.notifier) ;
  return userProfileController.getUserTweets(uid);
});
class UserProfileController extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  UserProfileController({required TweetApi tweetApi}): _tweetApi=tweetApi, super(false);
  Future<List<Tweet>> getUserTweets(String uid)async{
    final tweets=await _tweetApi.getUserTweets(uid);
    return tweets.map((e)=>Tweet.fromMap(e.data)).toList();
  }
  
}