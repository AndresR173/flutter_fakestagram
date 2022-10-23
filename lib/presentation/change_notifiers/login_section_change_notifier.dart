import 'package:flutter/material.dart';

import '../../data/repository.dart';
import '../pages/navigation_page.dart';

class LoginSectionChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;
  LoginSectionPageState _state = LoginSectionPageState.login;

  LoginSectionChangeNotifier(this._repository);

  void setLoginSectionPageState(LoginSectionPageState state) {
    _state = state;
    notifyListeners();
  }
}
