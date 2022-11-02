import 'package:flutter/material.dart';

import '../../data/repository.dart';
import 'future_state.dart';

class SearchChangeNotifier extends ChangeNotifier {
  SearchChangeNotifier(this._fakestagramRepository);

  final FakestagramRepository _fakestagramRepository;

  FutureState get imageListState => _imageListState;
  FutureState _imageListState = FutureState.wait;
  List<String> _imageBase64List = [];
  List<String> get imageBase64List => _imageBase64List;
  Object? error;

  Future<void> getImageList() async {
    _imageListState = FutureState.wait;
    notifyListeners();
    try {
      _imageBase64List = await _fakestagramRepository.getAllPhotos();
      _imageListState = FutureState.success;
    } catch (ex) {
      error = ex;
      _imageListState = FutureState.failure;
    } finally {
      notifyListeners();
    }
  }
}