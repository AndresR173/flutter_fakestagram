import 'package:fakestagram/data/repository.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';

class PostsChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  PostsChangeNotifier(this._repository) {
    _getPosts();
  }

  List<Post> posts = [];

  Future<void> _getPosts() async {
    posts = await _repository.getPosts();
    notifyListeners();
  }
}
