import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flatter_conn/constants/appwrite_constants.dart';
import 'package:flatter_conn/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageAPIProvider = Provider((ref) {
  return StorageApi(
    storage: ref.watch(appwriteStorageProvider),
  );
});

class StorageApi {
  final Storage _storage;
  StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> upLoadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(
        AppwriteConstants.imageURL(uploadedImage.$id),
      );
    }
    return imageLinks;
  }
}
