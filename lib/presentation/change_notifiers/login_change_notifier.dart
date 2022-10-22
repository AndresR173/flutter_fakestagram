import 'package:flutter/material.dart';

import '../../data/repository.dart';
import 'future_state.dart';

class LoginChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  LoginChangeNotifier(this._repository);

  String? _email;
  String? _password;
  dynamic _error;
  FutureState _state = FutureState.none;

  FutureState get state => _state;
  dynamic get error => _error;


  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  Future<void> login() async {
    if (_email == null || _password == null) {
      _state = FutureState.failure;
      _error = Exception('Email and password cannot be null');
      notifyListeners();
      return;
    }

    _state = FutureState.wait;
    notifyListeners();

    try {
      final token = await _repository.authenticate(_email!, _password!);
      if (token == null) throw Exception('invalid user or password');
      await _repository.saveAccessToken(token);
      _state = FutureState.success;
      notifyListeners();
    } catch (err) {
      _state = FutureState.failure;
      _error = err;
      notifyListeners();
    }
  }
}
