// services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AutenticacaoService {
  final String baseUrl = 'http://10.0.2.2:5000';

  Future<Map<String, dynamic>> cadastrar(  // ← muda String para Map<String, dynamic>
    String nome,
    String email,
    String senha,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cadastro'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome':  nome,
        'email': email,
        'senha': senha,
      }),
    );

    return jsonDecode(response.body); // ← retorna o Map completo
  }
}