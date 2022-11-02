import 'comment.dart';

class Post {
  final String id;
  final String author;
  final String imageBase64;
  final String header;
  final String avatar;
  final bool isLiked;
  final List<String>? likedBy;
  List<Comment>? comments;

  Post({
    required this.id,
    required this.isLiked,
    required this.author,
    required this.imageBase64,
    required this.header,
    required this.likedBy,
    required this.avatar,
  });



  int getLikesCount() => likedBy?.length ?? 0;

  int getCommentsCount() => comments?.length ?? 0;

}
