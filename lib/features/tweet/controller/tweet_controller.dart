import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flatter_conn/apis/storage_api.dart';
import 'package:flatter_conn/apis/tweet_api.dart';
import 'package:flatter_conn/core/core.dart';
import 'package:flatter_conn/features/auth/controller/auth_controller.dart';
import 'package:flatter_conn/models/tweet_model.dart';
import 'package:flatter_conn/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetApi: ref.watch(tweetAPIProvider),
    storageApi: ref.watch(storageAPIProvider),
  );
});

final getTweetProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});
final getRepliesToTweetProvider = FutureProvider.family((ref,Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});
final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

final getTweetByIdProvider = FutureProvider.family((ref,String id) async {
  final tweetController=ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

class TweetController extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  final StorageApi _storageApi;
  final Ref _ref;
  TweetController(
      {required Ref ref,
      required TweetApi tweetApi,
      required StorageApi storageApi})
      : _ref = ref,
        _tweetApi = tweetApi,
        _storageApi = storageApi,
        super(false);
  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetApi.getTweet();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, "PLease Enter Text");
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(images: images, text: text, context: context, repliedTo: repliedTo);
    } else {
      _shareTextTweet(text: text, context: context,repliedTo:repliedTo);
    }
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet)async{
    final documents=await _tweetApi.getRepliesToTweet(tweet);
    return documents.map((tweet)=>Tweet.fromMap(tweet.data)).toList();
  }
  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,

  }) async {
    state = true;
    final hashtags = _getHastagFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageApi.upLoadImage(images);
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      createdAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '', repliedTo: repliedTo
    );
    final res = await _tweetApi.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;
    final hashtags = _getHastagFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      createdAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetApi.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSetnence = text.split(' ');
    for (String word in wordsInSetnence) {
      if (word.startsWith('http://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHastagFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSetnence = text.split(' ');
    for (String word in wordsInSetnence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Future<Tweet> getTweetById(String id)async{
    final tweet=await _tweetApi.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

  void likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    tweet = tweet.copyWith(
      likes: likes,
    );
    final res = await _tweetApi.likeTweet(tweet);
    res.fold((l) => null, (r) => null);
  }

  void reshareTweet(
    Tweet tweet,
    UserModel currentUser,
    BuildContext context,
  ) async {
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount + 1,
    );
    final res = await _tweetApi.updateReshareCount(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      tweet = tweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
      );
      final res2 = await _tweetApi.shareTweet(tweet);

      res2.fold(
        (l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, '🔁 reConned!'),
      );
    });
  }
 
}
