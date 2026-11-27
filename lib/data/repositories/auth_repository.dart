import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../core/api_exception.dart';
import '../../core/token_storage.dart';

class AuthRepository {
  final ApiClient api;
  final TokenStorage storage;
  AuthRepository(this.api, this.storage);

  Future<void> login(String email, String password) async {
    try {
      final r = await api.dio.post('/login', data: {'email': email, 'password': password});
      await storage.save(r.data['token']);
    } on DioException catch (e) { throw ApiException.from(e); }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final r = await api.dio.post('/register', data: {
        'name': name, 'email': email,
        'password': password, 'password_confirmation': password,
      });
      await storage.save(r.data['token']);
    } on DioException catch (e) { throw ApiException.from(e); }
  }

  Future<bool> tryAutoLogin() async {
    if (await storage.read() == null) return false;
    try { await api.dio.get('/me'); return true; }
    on DioException catch (e) {
      if (e.response?.statusCode == 401) await storage.clear();
      return false;
    }
  }

  Future<void> logout() async {
    try { await api.dio.post('/logout'); } catch (_) {}
    await storage.clear();
  }
}