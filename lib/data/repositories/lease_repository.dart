import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../core/api_exception.dart';

class LeaseRepository {
  final ApiClient api;
  LeaseRepository(this.api);

  Future<void> createLease(int roomId, String start, String end) async {
    try {
      await api.dio.post('/leases', data: {
        'room_id': roomId, 'start_date': start, 'end_date': end,
      });
    } on DioException catch (e) { throw ApiException.from(e); }
  }
}