import 'package:fakestagram/presentation/change_notifiers/posts_change_notifier.dart';
import 'package:fakestagram/presentation/widgets/post_card.dart';
import 'package:fakestagram/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Consumer<PostsChangeNotifier>(
        builder: (context, value, child) {
          final posts = value.posts;
          if (posts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemBuilder: ((context, index) {
              final post = posts[index];
              return PostCard(post: post);
            }),
            itemCount: posts.length,
          );
        },
      ),
    );
  }
}
