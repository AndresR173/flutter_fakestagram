import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../models/unauthorized_exception.dart';
import '../../utils/assets.dart';
import '../change_notifiers/future_state.dart';
import '../change_notifiers/posts_change_notifier.dart';
import '../dialog/general_dialog.dart';
import '../widgets/post_card.dart';
import 'comments_page.dart';
import 'login_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final changeNotifier = context.read<PostsChangeNotifier>();
    changeNotifier.addListener(() {
      if (changeNotifier.fetchPostsState == FutureState.failure) {
        if (changeNotifier.error is UnauthorizedException) {
          if (!mounted) return;
          showGenericDialog(
            context,
            'the session token has expired',
            title: 'Error',
            onOkPressed: () async {
              await changeNotifier.deleteSession();
              unawaited(Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              ));
            },
          );
        } else {
          if (!mounted) return;
          showGenericDialog(
            context,
            'error: ${changeNotifier.error}',
            title: 'Error',
          );
        }
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      changeNotifier.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Consumer<PostsChangeNotifier>(
        builder: (_, changeNotifier, __) {
          final posts = changeNotifier.posts;
          if (changeNotifier.fetchPostsState == FutureState.success) {
            return RefreshIndicator(
              onRefresh: () async {
                await changeNotifier.getPosts();
              },
              child: ListView.builder(
                itemBuilder: (_, index) {
                  final post = posts[index];
                  return PostCard(
                    post: post,
                    onComment: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommentsPage(
                            post: post,
                            onPostAdded: () => changeNotifier.getPosts(),
                          ),
                        ),
                      );
                    },
                    onLike: () async {
                      await changeNotifier.likePost(post);
                      await changeNotifier.getPosts();
                    },
                  );
                },
                itemCount: posts.length,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
