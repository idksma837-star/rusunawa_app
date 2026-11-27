import 'package:dio/dio.dart';
import 'token_storage.dart';

class ApiClient {
  final TokenStorage storage;
  late final Dio dio;

  ApiClient(this.storage) {
    dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (o, h) async {
        final t = await storage.read();
        if (t != null) o.headers['Authorization'] = 'Bearer $t';
        h.next(o);
      },
    ));
  }
}