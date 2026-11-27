import 'package:flutter/material.dart';
import '../core/api_exception.dart';
import '../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repo;
  AuthViewModel(this.repo);

  bool loading = false;
  String? error;
  Map<String, String> fieldErrors = {};

  Future<bool> _run(Future<void> Function() action) async {
    loading = true; error = null; fieldErrors = {};
    notifyListeners();
    try { await action(); return true; }
    on ApiException catch (e) {
      error = e.message; fieldErrors = e.fieldErrors; return false;
    } finally { loading = false; notifyListeners(); }
  }

  Future<bool> login(String email, String pass) => _run(() => repo.login(email, pass));
  Future<bool> register(String name, String email, String pass) =>
      _run(() => repo.register(name, email, pass));
  Future<void> logout() => repo.logout();
}