import 'comment.dart';

class Post {
  final String id;
  final String image;
  final String header;
  final List<String> likedBy;
  final String avatar;
  List<Comment>? comments;

  Post({
    required this.id,
    required this.image,
    required this.header,
    required this.likedBy,
    required this.avatar,
  });

  bool getIsLiked(String? accountEmail) => likedBy.contains(accountEmail);
  int getLikesCount() => likedBy.length;
  int getCommentsCount() => comments?.length ?? 0;
}
