import 'package:flutter/material.dart';

import '../../utils/assets.dart';

class FakestagramAppBar extends AppBar {
  FakestagramAppBar({super.key, bool hideButtons = false, String? title})
      : super(
          backgroundColor: AppColors.primaryColor,
          centerTitle: false,
          title: title?.isNotEmpty == true
              ? Text(title!)
              : Image.asset(
                  Assets.titleImage,
                  height: 33,
                ),
          actions: hideButtons
              ? null
              : <Widget>[
                  Image.asset(
                    Assets.addOutline,
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.favorite_border,
                      size: 24,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.send,
                      size: 24,
                    ),
                  ),
                ],
        );
}
