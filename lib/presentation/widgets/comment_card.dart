import 'package:flutter/material.dart';

import '../../models/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          comment.author,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            comment.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
