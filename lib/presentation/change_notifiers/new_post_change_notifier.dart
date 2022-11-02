import 'package:flutter/material.dart';

import '../../data/repository.dart';
import 'future_state.dart';

class NewPostChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  NewPostChangeNotifier(this._repository);

  String? _pickedImagePath;

  String? get pickedImagePath => _pickedImagePath;
  
  String? _imageBase64;
  
  String? get imageBase64 => _imageBase64;

  FutureState _pickedImageState = FutureState.none;

  FutureState get pickedImageState => _pickedImageState;
  

  void setPickedImageState(FutureState value) {
    _pickedImageState = value;
    notifyListeners();
  }

  void setBase64(String? value) {
    _imageBase64 = value;
    notifyListeners();
  }
}
