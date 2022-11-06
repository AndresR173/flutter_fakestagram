import 'package:flutter/material.dart';

import '../../utils/assets.dart';

Future<T?> showGenericBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) =>
    showModalBottomSheet(
      context: context,
      barrierColor: AppColors.fiord.withOpacity(0.7),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      backgroundColor: AppColors.primaryColor,
      builder: builder,
    );