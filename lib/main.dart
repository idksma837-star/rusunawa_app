import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api_client.dart';
import 'core/token_storage.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/room_repository.dart';
import 'data/repositories/lease_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/room_list_viewmodel.dart';
import 'viewmodels/lease_viewmodel.dart';
import 'views/splash_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/room_list_screen.dart';

void main() {
  final storage = TokenStorage();
  final api = ApiClient(storage);
  final authRepo = AuthRepository(api, storage);
  final roomRepo = RoomRepository(api);
  final leaseRepo = LeaseRepository(api);

  runApp(MultiProvider(
    providers: [
      Provider.value(value: authRepo),
      Provider.value(value: roomRepo),
      ChangeNotifierProvider(create: (_) => AuthViewModel(authRepo)),
      ChangeNotifierProvider(create: (_) => RoomListViewModel(roomRepo)),
      ChangeNotifierProvider(create: (_) => LeaseViewModel(leaseRepo)),
    ],
    child: MaterialApp(
      title: 'Rusunawa',
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const RoomListScreen(),
      },
    ),
  ));
}