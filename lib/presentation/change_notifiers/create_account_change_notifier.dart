import 'package:flutter/material.dart';

import '../../data/repository.dart';

class CreateAccountChangeNotifier extends ChangeNotifier {
  final FakestagramRepository _repository;

  CreateAccountChangeNotifier(this._repository);

  Future<void> createAccount() async {}
}
