import 'dart:async';

import 'package:fakestagram/presentation/dialog/general_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/unauthorized_exception.dart';
import '../../utils/assets.dart';
import '../change_notifiers/future_state.dart';
import '../change_notifiers/posts_change_notifier.dart';
import '../widgets/post_card.dart';
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
    provider.init();
    provider.addListener(() {
      if (provider.fetchPostsState == FutureState.failure) {
        if (provider.error is UnauthorizedException) {
          if (!mounted) return;
          showGenericDialog(context, 'the session token has expired', title: 'Error', onOkPressed: () async {
            await provider.deleteSession();
            unawaited(Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            ));
          });
        } else {
          if (!mounted) return;
          showGenericDialog(context, 'error: ${provider.error}', title: 'Error');
        }
      }
    });
    
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
                return PostCard(post: post);
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
}

Future<void> _showPostCommentBottomSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      barrierColor: AppColors.fiord.withOpacity(0.7),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return const SafeArea(
            child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Write a message...',
          ),
        ));
      },
    );
