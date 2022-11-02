import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../models/comment.dart';
import '../../models/post.dart';
import '../../utils/assets.dart';
import '../change_notifiers/comments_change_notifier.dart';
import '../change_notifiers/future_state.dart';
import '../dialog/general_dialog.dart';
import '../widgets/comment_card.dart';
import '../widgets/fakestagram_app_bar.dart';
import '../widgets/progress_widget.dart';

class CommentsPage extends StatefulWidget {
  final Post post;

  const CommentsPage({
    super.key,
    required this.post,
  });

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
  void initState() {
    super.initState();
    final changeNotifier = context.read<CommentsChangeNotifier>();
    changeNotifier.addListener(() {
     if (changeNotifier.getCommentsState == FutureState.failure ||
          changeNotifier.postCommentsState == FutureState.failure) {
        if (!mounted) return;
        showGenericDialog(context, 'error: ${changeNotifier.error}', title: 'Error');
      }
    });
    changeNotifier.init();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      changeNotifier.getComments(widget.post.id);
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final changeNotifier = context.read<CommentsChangeNotifier>();
        Navigator.pop(context, changeNotifier.commentWasAdded);
        return false;
      },
      child: Scaffold(
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
                  child: Consumer<CommentsChangeNotifier>(builder: (_, changeNotifier, __) {
                    if (changeNotifier.getCommentsState == FutureState.success) {
                      return ListView.separated(
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 5,
                        ),
                        itemBuilder: (_, index) => CommentCard(comment: changeNotifier.comments[index]),
                        itemCount: changeNotifier.comments.length,
                      );
                    } else {
                      return const ProgressWidget();
                    }
                  }),
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
                          onPressed: () async {
                            final changeNotifier = context.read<CommentsChangeNotifier>();
                            await changeNotifier.postComment(widget.post.id, _commentController.text);
                            _commentController.clear();
                            await changeNotifier.getComments(widget.post.id);
                          },
                          icon: const Icon(Icons.send, color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
