import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repository.dart';
import 'presentation/change_notifiers/login_change_notifier.dart';
import 'presentation/change_notifiers/posts_change_notifier.dart';
import 'presentation/pages/navigation_page.dart';
import 'utils/assets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final repository = FakestagramRepository(sharedPreferences);
  final token = await repository.getAccessToken();
  if (token != null) print('token: ${token.idToken}');

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final FakestagramRepository repository;

  const MyApp({super.key, required this.repository});

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
            create: (_) => PostsChangeNotifier(repository),
          ),
          ChangeNotifierProvider<LoginChangeNotifier>(
            create: (_) => LoginChangeNotifier(repository),
          ),
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
