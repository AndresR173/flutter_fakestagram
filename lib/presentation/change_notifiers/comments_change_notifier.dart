import 'package:flutter/foundation.dart';

import '../../data/repository.dart';
import '../../models/comment.dart';
import 'future_state.dart';

class CommentsChangeNotifier extends ChangeNotifier {

  final FakestagramRepository _repository;

  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  FutureState _getCommentsState = FutureState.none;

  FutureState _postCommentState = FutureState.none;
  
  FutureState get postCommentsState => _postCommentState;

  FutureState get getCommentsState => _getCommentsState;

  bool commentWasAdded = false;

  dynamic _error;

  dynamic get error => _error;

  CommentsChangeNotifier(this._repository);

  void init() {
    _comments = [];
    _getCommentsState = FutureState.wait;
    _postCommentState = FutureState.none;
    commentWasAdded = false;
    _error = null;
  }

  Future<void> getComments(String postId) async {
    _getCommentsState = FutureState.wait;
    notifyListeners();
    try {
      _comments = await _repository.getCommentsByPost(postId).then((commentList) => commentList ?? []);
      _getCommentsState = FutureState.success;

    } catch (e) {
      _error = e;
      _getCommentsState = FutureState.failure;
    }
    notifyListeners();
  }

  Future<void> postComment(String postId, String text) async {
    _postCommentState = FutureState.wait;
    notifyListeners();
    try {
      await _repository.postComment(postId, text);
      commentWasAdded = true;
      _postCommentState = FutureState.success;
    } catch (e) {
      _error = e;
      _postCommentState = FutureState.failure;
    }
    notifyListeners();
  }
}