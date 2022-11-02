import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repository.dart';
import 'future_state.dart';

class NewPostChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  NewPostChangeNotifier(this._repository);

  String? _imageBase64;

  String? get imageBase64 => _imageBase64;

  String? _headerText;

  String? get headerText => _headerText;

  FutureState _pickedImageState = FutureState.none;

  FutureState get pickedImageState => _pickedImageState;

  void setPostText(String? text) {
    _headerText = text;
  }

  void setPickedImageState(FutureState value) {
    _pickedImageState = value;
    notifyListeners();
  }

  void setBase64(String? value) {
    _imageBase64 = value;
    notifyListeners();
  }

  Future<void> captureImageAndProcess({
    required ImageSource imageSource,
    required ValueChanged<String?> onSuccess,
    required ValueChanged<Object> onFailure,
  }) async {
    _pickedImageState = FutureState.wait;
    notifyListeners();

    try {
      final base64Image = await _repository.processAndDispatchImage(imageSource: imageSource);
      _pickedImageState = FutureState.success;
      onSuccess(base64Image);
    } catch (e) {
      _pickedImageState = FutureState.failure;
      onFailure(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> makePost({required VoidCallback onPostSuccess, required ValueChanged<Object> onPostFailure}) async {
    try {
      if (_imageBase64?.isEmpty == true || _headerText?.isEmpty == true) {
        throw Exception('image or text is empty');
      }

      await _repository.postNewEntry(imageBase64: _imageBase64!, header: _headerText!);
      setPickedImageState(FutureState.success);
      onPostSuccess();
    } catch (e) {
      onPostFailure(e);
    }
  }
}
