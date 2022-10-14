import 'package:fakestagram/data/repository.dart';
import 'package:flutter/material.dart';

class PostsChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  PostsChangeNotifier(this._repository);
}
