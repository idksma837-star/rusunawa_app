import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repositories/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final ok = await context.read<AuthRepository>().tryAutoLogin();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, ok ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}