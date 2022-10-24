import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../change_notifiers/create_account_change_notifier.dart';
import '../change_notifiers/future_state.dart';
import '../dialog/general_dialog.dart';
import '../widgets/fakestagram_app_bar.dart';
import 'navigation_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<CreateAccountChangeNotifier>();
    provider.init();
    provider.addListener(() {
      switch (provider.state) {
        case FutureState.success:
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const NavigationPage()),
              (route) => false);
          break;
        case FutureState.failure:
          if (!mounted) return;
          Navigator.pop(context);
          showGenericDialog(
            context,
            'error: ${provider.error}',
            title: 'Error',
          );
          break;
        case FutureState.wait:
          if (!mounted) return;
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<CreateAccountChangeNotifier>(
              builder: (_, changeNotifier, __) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Create Account',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (text) => changeNotifier.setEmail(text),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (text) => changeNotifier.setPassword(text),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (text) =>
                      changeNotifier.setPasswordConfirmation(text),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => changeNotifier.createAccount(),
                  child: const Text('Create Account'),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
