import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flatter_conn/constants/appwrite_constants.dart';
import 'package:flatter_conn/core/core.dart';
import 'package:flatter_conn/models/tweet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetApi(
    db: ref.watch(
      appwritedatabaseProvider,
    ),
    realtime: ref.watch(
      appwriteRealtimeProvider,
    ),
  );
});

abstract class ITweetApi {
  FutureEither<models.Document> shareTweet(Tweet tweet);
  Future<List<models.Document>> getTweet();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<models.Document> likeTweet(Tweet tweet);
  FutureEither<models.Document> updateReshareCount(Tweet tweet);
  Future<List<models.Document>> getRepliesToTweet(Tweet tweet);
  Future<models.Document> getTweetById(String id);
  Future<List<models.Document>> getUserTweets(String uid);
}

class TweetApi implements ITweetApi {
  final Databases _db;
  final Realtime _realtime;
  TweetApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;
  @override
  FutureEither<models.Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected Error', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<models.Document>> getTweet() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        queries: [Query.orderDesc('createdAt')]);

    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollectionId}.documents'
    ]).stream;
  }

  @override
  FutureEither<models.Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollectionId,
          documentId: tweet.id,
          data: {
            'likes': tweet.likes,
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'Unexpected Error', st),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }

  @override
  FutureEither<models.Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollectionId,
          documentId: tweet.id,
          data: {
            'reshareCount': tweet.reshareCount,
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'Unexpected Error', st),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }

  @override
  Future<List<models.Document>> getRepliesToTweet(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollectionId,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ],
    );
    return document.documents;
  }
  
  @override
  Future<models.Document> getTweetById(String id) {
    return _db.getDocument(databaseId: AppwriteConstants.databaseId, collectionId: AppwriteConstants.tweetsCollectionId, documentId: id);
  }
  
  @override
  Future<List<models.Document>> getUserTweets(String uid)async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        queries: [
          Query.equal('uid', uid),
        ],);

    return documents.documents;
  }
}
