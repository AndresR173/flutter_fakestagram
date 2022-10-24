import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repository.dart';
import 'presentation/change_notifiers/account_change_notifier.dart';
import 'presentation/change_notifiers/create_account_change_notifier.dart';
import 'presentation/change_notifiers/login_change_notifier.dart';
import 'presentation/change_notifiers/posts_change_notifier.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/navigation_page.dart';
import 'utils/assets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final repository = FakestagramRepository(sharedPreferences);
  final isLoggedIn = await repository.isUserLoggedIn();
  runApp(MyApp(repository: repository, isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final FakestagramRepository repository;
  final bool isLoggedIn;

  const MyApp({super.key, required this.repository, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostsChangeNotifier>(
          create: (_) => PostsChangeNotifier(repository),
        ),
        ChangeNotifierProvider<LoginChangeNotifier>(
          create: (_) => LoginChangeNotifier(repository),
        ),
        ChangeNotifierProvider<AccountChangeNotifier>(
          create: (_) => AccountChangeNotifier(repository),
        ),
        ChangeNotifierProvider<CreateAccountChangeNotifier>(
          create: (_) => CreateAccountChangeNotifier(repository),
        )
      ],
      child: MaterialApp(
        title: 'Fakestagram',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
          child: isLoggedIn ? const NavigationPage() : const LoginPage(),
        ),
      ),
    );
  }
}
