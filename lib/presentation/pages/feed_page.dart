import 'dart:async';

import 'package:flutter/material.dart';
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

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<PostsChangeNotifier>();
    provider.addListener(() {
      if (provider.fetchPostsState == FutureState.failure) {
        if (provider.error is UnauthorizedException) {
          if (!mounted) return;
          showGenericDialog(
            context,
            'the session token has expired',
            title: 'Error',
            onOkPressed: () async {
              await provider.deleteSession();
              unawaited(Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              ));
            },
          );
        } else {
          if (!mounted) return;
          showGenericDialog(context, 'error: ${provider.error}', title: 'Error');
        }
      }
    });
    fetchPosts(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Consumer<PostsChangeNotifier>(
        builder: (_, changeNotifier, __) {
          final posts = changeNotifier.posts;
          if (changeNotifier.fetchPostsState == FutureState.success) {
            return ListView.builder(
              itemBuilder: (_, index) {
                final post = posts[index];
                return PostCard(
                  post: post,
                  onComment: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommentsPage(
                          comments: post.comments!,
                          onNewComment: (String comment) {
                            changeNotifier.commentPost(post, comment);
                          },
                        ),
                      ),
                    );
                  },
                  onLike: () {},
                );
              },
              itemCount: posts.length,
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

  void fetchPosts(PostsChangeNotifier provider) {
    provider.init();
    provider.getPosts();
  }
}
