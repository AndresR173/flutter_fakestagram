import 'package:flutter/material.dart';

import '../../data/repository.dart';
import '../../models/user_account.dart';
import 'future_state.dart';

class LoginChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  LoginChangeNotifier(this._repository);

  String? _email;
  String? _password;
  dynamic _error;
  FutureState _loginActionState = FutureState.none;

  FutureState get loginActionState => _loginActionState;

  dynamic get error => _error;

  void init() {
    _loginActionState = FutureState.none;
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


  Future<void> login() async {
    _loginActionState = FutureState.wait;
    notifyListeners();

    if (_email == null || _password == null) {
      _loginActionState = FutureState.failure;
      _error = Exception('Email and password cannot be null');
      notifyListeners();
      return;
    }

    try {
      final token = await _repository.authenticate(_email!, _password!);
      if (token == null) throw Exception('invalid user or password');
      await _repository.saveAccessToken(token);
      await _repository.saveUserAccount(UserAccount(email: _email!));
      _loginActionState = FutureState.success;
    } catch (err) {
      _loginActionState = FutureState.failure;
      _error = err;
    }
    notifyListeners();
  }
}
