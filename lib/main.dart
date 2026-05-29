import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/auth/login.dart';
import 'services/auth_service.dart';
import 'screens/bottom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
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
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR')
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      home: logado
          ? const Bottom()
          : const LoginPage(),
    );
  }
}