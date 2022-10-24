import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/assets.dart';
import '../change_notifiers/future_state.dart';
import '../change_notifiers/login_change_notifier.dart';
import '../dialog/general_dialog.dart';
import '../widgets/fakestagram_app_bar.dart';
import 'create_account_page.dart';
import 'navigation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<LoginChangeNotifier>();
    provider.init();
    provider.addListener(() {
      switch (provider.loginActionState) {
        case FutureState.success:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationPage()),
            (route) => false,
          );
          break;
        case FutureState.failure:
          Navigator.pop(context);
          showGenericDialog(context, 'error: ${provider.error}', title: 'Error');
          break;
        case FutureState.wait:
          showProgressDialog(context);
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FakestagramAppBar(hideButtons: true),
      body: ColoredBox(
        color: Colors.white,
        child: Consumer<LoginChangeNotifier>(builder: (_, changeNotifier, __) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.logo, height: 50),
                const SizedBox(height: 30),
                TextField(
                  onChanged: (text) => changeNotifier.setEmail(text),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  onChanged: (text) => changeNotifier.setPassword(text),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () => changeNotifier.login(),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateAccountPage(),
                          )),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
        }),
      ),
    );
  }
}
