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
  Object? _error;

  Object? get error => _error;

  Future<void> getPosts() async {
    _getPostsState = FutureState.wait;
    notifyListeners();
    try {
      _posts = await _repository.getPosts();
      _getPostsState = FutureState.success;
    } catch (e) {
      _getPostsState = FutureState.failure;
      _error = e;
    }
    notifyListeners();
  }

  Future<void> likePost(Post post) => _repository.likePost(post);

  Future<void> getPostsNoWait() async {
    try {
      _posts = await _repository.getPosts();
    } catch (e) {
      _getPostsState = FutureState.failure;
      _error = e;
    }
    notifyListeners();
  }

  Future<void> deleteSession() => _repository.deleteAccessToken();
}
