import 'dart:math';

import 'package:flutter/material.dart';

import 'user_image.dart';

class Story extends StatelessWidget {
  final int index;
  const Story({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              right: 4,
              left: 4,
              bottom: 4,
            ),
            child: UserImage(
                image:
                    'https://randomuser.me/api/portraits/med/men/${random.nextInt(40)}.jpg',
                radio: 35,
                width: 75),
          ),
          Text(
            "user $index",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
