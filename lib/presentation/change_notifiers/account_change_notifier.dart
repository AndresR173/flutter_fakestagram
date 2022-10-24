import 'package:flutter/material.dart';

import '../../data/repository.dart';
import '../../models/user_account.dart';
import 'future_state.dart';

class AccountChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;
  UserAccount? _userAccount;

  UserAccount? get userAccount => _userAccount;

  FutureState _logoutActionState = FutureState.none;

  FutureState get logoutActionState => _logoutActionState;

  AccountChangeNotifier(this._repository) {
    _init();
  }

  Future<void> _init() async {
    _userAccount = await _repository.getUserAccount();
    notifyListeners();
  }

  Future<void> logout() async {
    _logoutActionState = FutureState.wait;
    notifyListeners();
    await _repository.deleteAccessToken();
    _logoutActionState = FutureState.success;
    notifyListeners();
  }
}
