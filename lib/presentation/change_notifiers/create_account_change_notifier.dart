import 'package:flutter/material.dart';

import '../../data/repository.dart';
import 'future_state.dart';

class CreateAccountChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  CreateAccountChangeNotifier(this._repository);

  String? _email;
  String? _password;
  String? _passwordConfirmation;

  dynamic _error;
  FutureState _state = FutureState.none;

  FutureState get state => _state;

  dynamic get error => _error;

  void init() {
    _state = FutureState.none;
    _error = null;
    _email = null;
    _password = null;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  void setPasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
  }

  Future<void> createAccount() async {
    _state = FutureState.wait;
    notifyListeners();

    if (_email == null || _password == null) {
      _state = FutureState.failure;
      _error = Exception('Email and password cannot be null');
      notifyListeners();
      return;
    } else if (_password != _passwordConfirmation) {
      _state = FutureState.failure;
      _error = Exception('Passwords do not match');
      notifyListeners();
      return;
    }

    try {
      final isAccountCreated = await _repository.createAccount(_email!, _password!);
      if (!isAccountCreated) throw Exception('username or password already exists');
      _state = FutureState.success;
      notifyListeners();
    } catch (err) {
      _state = FutureState.failure;
      _error = err;
      notifyListeners();
    }
  }
}
