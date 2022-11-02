import 'package:flutter/material.dart';

import '../../data/repository.dart';
import '../../models/post.dart';
import '../../models/user_account.dart';
import 'future_state.dart';

class PostsChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  PostsChangeNotifier(this._repository);

  List<Post> _posts = [];

  List<Post> get posts => _posts;

  FutureState _getPostsState = FutureState.none;

  FutureState get fetchPostsState => _getPostsState;

  UserAccount? _userAccount;

  UserAccount? get userAccount => _userAccount;

  dynamic _error;

  dynamic get error => _error;

  void init() {
    _posts = [];
    _getPostsState = FutureState.wait;
    _error = null;
    _userAccount = _repository.getAccountEmail();
  }

  Future<void> getPosts() async {
    _getPostsState = FutureState.wait;
    try {
      _posts = await _repository.getPosts();
      _getPostsState = FutureState.success;

    } catch (e) {
      _getPostsState = FutureState.failure;
      _error = e;
    }
    notifyListeners();
  }

  Future<void> likePost(Post post) async {

  }





  Future<void> deleteSession() => _repository.deleteAccessToken();
}
