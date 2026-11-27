import 'package:flutter/material.dart';
import '../core/api_exception.dart';
import '../data/models/room.dart';
import '../data/repositories/room_repository.dart';

enum ViewState { loading, success, empty, error }

class RoomListViewModel extends ChangeNotifier {
  final RoomRepository repo;
  RoomListViewModel(this.repo);

  ViewState state = ViewState.loading;
  List<Room> rooms = [];
  String? error;
  String? status;

  Future<void> load({bool silent = false}) async {
    if (!silent) { state = ViewState.loading; notifyListeners(); }
    try {
      rooms = await repo.getRooms(status: status);
      state = rooms.isEmpty ? ViewState.empty : ViewState.success;
    } on ApiException catch (e) {
      error = e.message; state = ViewState.error;
    }
    notifyListeners();
  }

  void setStatus(String? s) { status = s; load(); }
}