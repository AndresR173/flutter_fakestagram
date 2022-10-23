import 'package:flutter/material.dart';

class CreateAccountPage extends StatelessWidget {
  final ValueChanged<bool> onRegister;

  const CreateAccountPage({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Create Account Page'),
        const SizedBox(
          height: 20,
        ),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Confirm Password',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Create Account'),
        ),
      ],
    );
  }
}
