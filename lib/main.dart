import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/login.dart';
import 'screens/imoveis.dart';
import 'services/auth_service.dart';
import 'screens/Bottom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool logado = await AuthService().isLogged();
  runApp(MyApp(logado: logado));
}

class MyApp extends StatelessWidget {
  final bool logado;

  const MyApp({
    super.key,
    required this.logado
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: logado
          ? const Bottom()
          : const LoginPage(),
    );
  }
}