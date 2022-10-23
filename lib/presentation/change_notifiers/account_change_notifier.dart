import 'package:flutter/material.dart';

import '../../data/repository.dart';

class AccountChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  AccountChangeNotifier(this._repository);

  Future<void> fetchAccount() async {}
}
