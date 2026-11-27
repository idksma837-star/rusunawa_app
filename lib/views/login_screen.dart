import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: email,
              decoration: InputDecoration(labelText: 'Email', errorText: vm.fieldErrors['email'])),
          TextField(controller: pass, obscureText: true,
              decoration: InputDecoration(labelText: 'Password', errorText: vm.fieldErrors['password'])),
          if (vm.error != null && vm.fieldErrors.isEmpty)
            Padding(padding: const EdgeInsets.only(top: 8),
                child: Text(vm.error!, style: const TextStyle(color: Colors.red))),
          const SizedBox(height: 16),
          if (vm.loading) const CircularProgressIndicator()
          else ElevatedButton(
            onPressed: () async {
              final ok = await vm.login(email.text, pass.text);
              if (ok && context.mounted) Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text('Belum punya akun? Register'),
          ),
        ]),
      ),
    );
  }
}