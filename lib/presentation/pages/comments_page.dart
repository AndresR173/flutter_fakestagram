import 'package:flutter/material.dart';

import '../../models/comment.dart';
import '../../utils/assets.dart';
import '../widgets/comment_card.dart';
import '../widgets/fakestagram_app_bar.dart';

class CommentsPage extends StatefulWidget {
  final List<Comment> comments;
  final ValueChanged<String> onNewComment;

  const CommentsPage({
    Key? key,
    required this.comments,
    required this.onNewComment,
  }) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: FakestagramAppBar(
          title: 'Comments',
          hideButtons: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 5,
                  ),
                  itemBuilder: (_, index) {
                    final comment = widget.comments[index];
                    return CommentCard(comment: comment);
                  },
                  itemCount: widget.comments.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () => widget.onNewComment(_commentController.text),
                        icon: const Icon(Icons.send, color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
