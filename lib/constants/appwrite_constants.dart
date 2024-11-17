class AppwriteConstants{
  static const String databaseId="670fd4d0002119455062";
  static const String projectId="670fcf7c0015b80ca065";
  static const String endPoint="http://192.168.31.115/v1";
  static const String userCollectionId="67286738002c134306a7";
  static const String tweetsCollectionId="672cfc2600047d278064";
  static const String imagesBucket="672d07b1000b211124c8";

  static String imageURL(String imageID)=>'$endPoint/storage/buckets/$imagesBucket/files/$imageID/view?project=$projectId&project=$projectId&mode=admin';
}