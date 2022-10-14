import 'dart:math';

import 'package:flutter/material.dart';

class Likes extends StatelessWidget {
  const Likes({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${_getRandomNumber()} likes",
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  int _getRandomNumber() {
    final rnd = Random();
    return rnd.nextInt(1000);
  }
}
