
import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../core/api_exception.dart';
import '../models/room.dart';

class RoomRepository {
  final ApiClient api;
  RoomRepository(this.api);

  Future<List<Room>> getRooms({String? status}) async {
    try {
      final r = await api.dio.get('/rooms',
          queryParameters: {if (status != null) 'status': status});
      return (r.data['data'] as List).map((e) => Room.fromJson(e)).toList();
    } on DioException catch (e) { throw ApiException.from(e); }
  }

  Future<Room> getRoom(int id) async {
    try {
      final r = await api.dio.get('/rooms/$id');
      return Room.fromJson(r.data['data']);
    } on DioException catch (e) { throw ApiException.from(e); }
  }
}