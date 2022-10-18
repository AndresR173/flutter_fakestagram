import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/repository.dart';
import 'presentation/change_notifiers/posts_change_notifier.dart';
import 'presentation/pages/navigation_page.dart';
import 'utils/assets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _repository = FakestagramRepository();
  MyApp({super.key, required});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fakestagram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<PostsChangeNotifier>(
            create: (_) => PostsChangeNotifier(_repository),
          )
        ],
        child: const AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
          child: NavigationPage(),
        ),
      ),
    );
  }
}
