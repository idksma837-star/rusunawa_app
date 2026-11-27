import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, String> fieldErrors;
  ApiException(this.message, {this.statusCode, this.fieldErrors = const {}});

  factory ApiException.from(DioException e) {
    final code = e.response?.statusCode;
    final data = e.response?.data;
    if (code == 422 && data is Map) {
      final errs = <String, String>{};
      (data['errors'] as Map? ?? {}).forEach((k, v) {
        errs[k.toString()] = (v as List).first.toString();
      });
      return ApiException(data['message'] ?? 'Validasi gagal',
          statusCode: 422, fieldErrors: errs);
    }
    if (code == 401) return ApiException('Sesi berakhir', statusCode: 401);
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return ApiException('Tidak dapat terhubung ke server');
    }
    return ApiException(
        data is Map ? (data['message'] ?? 'Terjadi kesalahan') : 'Terjadi kesalahan',
        statusCode: code);
  }
}