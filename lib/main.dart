import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/login.dart';
import 'screens/imoveis.dart'; // Mantive o import da sua nova tela de imóveis
import 'services/auth_service.dart';

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
      // Estrutura oficial mantida. Mude para ImoveisPage(...) apenas se quiser testar isolado.
      home: logado
          ? const Dashboard()
          : const LoginPage(),
    );
  }
}