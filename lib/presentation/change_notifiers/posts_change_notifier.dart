import 'package:flutter/material.dart';

import '../../data/repository.dart';
import '../../models/post.dart';
import 'future_state.dart';

class PostsChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  PostsChangeNotifier(this._repository);

  List<Post> _posts = [];

  List<Post> get posts => _posts;

  FutureState _getPostsState = FutureState.none;

  FutureState get fetchPostsState => _getPostsState;

  dynamic _error;

  dynamic get error => _error;

  void init() {
    _posts = [];
    _getPostsState = FutureState.none;
    _error = null;
  }

  Future<void> getPosts() async {
    _getPostsState = FutureState.wait;
    try {
      _posts = await _repository.getPosts();
      _getPostsState = FutureState.success;
      notifyListeners();
    } catch (e) {
      _getPostsState = FutureState.failure;
      _error = e;
      notifyListeners();
    }
  }

  Future<void> deleteSession() => _repository.deleteAccessToken();
}
