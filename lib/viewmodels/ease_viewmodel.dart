import 'package:flutter/material.dart';
import '../core/api_exception.dart';
import '../data/repositories/lease_repository.dart';

class LeaseViewModel extends ChangeNotifier {
  final LeaseRepository repo;
  LeaseViewModel(this.repo);

  bool loading = false;
  String? error;
  Map<String, String> fieldErrors = {};

  Future<bool> submit(int roomId, String start, String end) async {
    loading = true; error = null; fieldErrors = {};
    notifyListeners();
    try { await repo.createLease(roomId, start, end); return true; }
    on ApiException catch (e) {
      error = e.message; fieldErrors = e.fieldErrors; return false;
    } finally { loading = false; notifyListeners(); }
  }
}