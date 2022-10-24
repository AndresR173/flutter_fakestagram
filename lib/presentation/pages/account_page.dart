import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../change_notifiers/account_change_notifier.dart';
import '../change_notifiers/future_state.dart';
import '../dialog/general_dialog.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<AccountChangeNotifier>();
    provider.init();
    provider.addListener(() {
      switch (provider.logoutActionState) {
        case FutureState.success:
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
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
    return Consumer<AccountChangeNotifier>(builder: (_, changeNotifier, __) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            //rounded box
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('Account Email', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      Text(changeNotifier.userAccount?.email ?? '')
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(onPressed: () => changeNotifier.logout(), child: const Text('Log Out')),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
