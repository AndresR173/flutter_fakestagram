import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/post.dart';
import 'likes.dart';
import 'random_image.dart';
import 'user_image.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onComment;
  final VoidCallback onLike;

  const PostCard({
    super.key,
    required this.post,
    required this.onComment,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildHeader(),
        buildImage(),
        buildActions(),
        buildLikes(),
        if (post.comments?.isNotEmpty == true) buildComments(),
      ]),
    );
  }

  Widget buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: RandomImage(media: 'https://picsum.photos/id/${Random().nextInt(80)}/200'),
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 20),
                child: UserImage(
                  image: post.avatar,
                  radio: 16,
                  width: 38,
                ),
              ),
              const Text(
                'User name',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 25),
          child: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget buildActions() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: onLike,
              ),
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: onComment,
              ),
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 25),
          child: Icon(
            Icons.bookmark_outline,
            color: Colors.white,
            size: 24,
          ),
        )
      ],
    );
  }

  Widget buildLikes() {
    return const Padding(
      padding: EdgeInsets.only(left: 20, top: 5),
      child: Likes(),
    );
  }

  Widget buildComments() => Padding(
    padding: const EdgeInsets.only(left: 20, top: 5),
    child: Text(
          'View all ${post.comments?.length} comments',
          style: const TextStyle(color: Colors.white),
        ),
  );
}
