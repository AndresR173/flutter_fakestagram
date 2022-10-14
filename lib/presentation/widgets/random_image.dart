import 'package:flutter/material.dart';

class RandomImage extends StatelessWidget {
  final String media;
  const RandomImage({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      media,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.5,
    );
  }
}
