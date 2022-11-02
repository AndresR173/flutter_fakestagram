import 'package:flutter/material.dart';

import '../../data/repository.dart';
import 'future_state.dart';

class NewPostChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  NewPostChangeNotifier(this._repository);

  String? _pickedImagePath;

  String? get pickedImagePath => _pickedImagePath;

  FutureState _pickedImageState = FutureState.none;

  FutureState get pickedImageState => _pickedImageState;

  void setPickedImagePath(String? value) {
    _pickedImagePath = value;
    notifyListeners();
  }

  void setPickedImageState(FutureState value) {
    _pickedImageState = value;
    notifyListeners();
  }
}
