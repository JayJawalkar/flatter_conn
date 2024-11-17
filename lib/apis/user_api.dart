import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flatter_conn/constants/appwrite_constants.dart';
import 'package:flatter_conn/core/core.dart';
import 'package:flatter_conn/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userAPIProvider = Provider((ref) {
  return UserApi(db: ref.watch(appwritedatabaseProvider));
});

abstract class IUserApi {
  FutureEitherVoid savedUserData(UserModel userModel);
  Future<models.Document> getUserData(String uid);
  Future<List<models.Document>> searchUserByName(String name);
}

class UserApi implements IUserApi {
  final Databases _db;
  UserApi({required Databases db}) : _db = db;
  @override
  FutureEitherVoid savedUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? "UnExepcted Error",
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    }
  }

  @override
  Future<models.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userCollectionId,
      documentId: uid,
    );
  }
  
  @override
  Future<List<models.Document>> searchUserByName(String name)async {
   final documents=await _db.listDocuments(databaseId: AppwriteConstants.databaseId, collectionId: AppwriteConstants.userCollectionId,
   queries: [
    Query.search('name', name)
   ]
   );
   return documents.documents;
  }
}
