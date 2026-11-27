import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: name,
              decoration: InputDecoration(labelText: 'Nama', errorText: vm.fieldErrors['name'])),
          TextField(controller: email,
              decoration: InputDecoration(labelText: 'Email', errorText: vm.fieldErrors['email'])),
          TextField(controller: pass, obscureText: true,
              decoration: InputDecoration(labelText: 'Password (min 8)', errorText: vm.fieldErrors['password'])),
          const SizedBox(height: 16),
          if (vm.loading) const CircularProgressIndicator()
          else ElevatedButton(
            onPressed: () async {
              final ok = await vm.register(name.text, email.text, pass.text);
              if (ok && context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
              }
            },
            child: const Text('Daftar'),
          ),
        ]),
      ),
    );
  }
}