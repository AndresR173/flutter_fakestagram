import 'comment.dart';

class Post {
  final String id;
  final String image;
  final String header;
  final bool isLiked;
  final String avatar;
  List<Comment>? comments;

  Post({
    required this.id,
    required this.image,
    required this.header,
    required this.isLiked,
    required this.avatar,
  });
}
