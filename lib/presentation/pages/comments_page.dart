import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../data/repository.dart';
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
  final VoidCallback? onPostAdded;

  const CommentsPage({super.key, required this.post, this.onPostAdded});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _commentController = TextEditingController();
  late CommentsChangeNotifier _changeNotifier;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _changeNotifier = CommentsChangeNotifier(
      context.read<FakestagramRepository>(),
    );
    _changeNotifier.postId = widget.post.id ?? '';
    _changeNotifier.addListener(() {
      if (_changeNotifier.getCommentsState == FutureState.failure || _changeNotifier.postCommentsState == FutureState.failure) {
        if (!mounted) return;
        showGenericDialog(
          context,
          'error: ${_changeNotifier.error}',
          title: 'Error',
        );
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _changeNotifier.getComments();
    });
  }

  @override
  Widget build(BuildContext oldContext) {
    return ChangeNotifierProvider(
      create: (_) => _changeNotifier,
      builder: (context, _) {
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
                  child: Consumer<CommentsChangeNotifier>(builder: (_, changeNotifier, __) {
                    if (changeNotifier.getCommentsState == FutureState.success) {
                      return ListView.separated(
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 5,
                        ),
                        itemBuilder: (_, index) => CommentCard(
                          comment: changeNotifier.comments[index],
                        ),
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
                          if (widget.post.id == null) return;
                          final changeNotifier = context.read<CommentsChangeNotifier>();
                          await changeNotifier.postComment(widget.post.id!, _commentController.text);
                          _commentController.clear();
                          widget.onPostAdded?.call();
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
