import 'package:fakestagram/widgets/likes.dart';
import 'package:fakestagram/widgets/random_image.dart';
import 'package:fakestagram/widgets/user_image.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Column(children: <Widget>[
        buildHeader(),
        buildImage(),
        buildActions(),
        buildLikes()
      ]),
    );
  }

  Widget buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: RandomImage(media: post.media),
    );
  }

  Widget buildHeader() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 20),
                child: UserImage(
                  image: post.avatarImage,
                  radio: 16,
                  width: 38,
                ),
              ),
              Text(
                post.accountName,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
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
      children: <Widget>[
        Expanded(
          child: Row(
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10, left: 20),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Icon(Icons.send, color: Colors.white, size: 35),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 25),
          child: Icon(Icons.save, color: Colors.white, size: 35),
        )
      ],
    );
  }

  Widget buildLikes() {
    return Row(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, top: 5),
          child: Likes(),
        ),
      ],
    );
  }
}
