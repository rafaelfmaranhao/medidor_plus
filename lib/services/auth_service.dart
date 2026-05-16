// services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AutenticacaoService {
  final String baseUrl = 'http://10.0.2.2:5000';

  Future<String> cadastrar(String nome, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cadastro'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome':  nome,
        'email': email,
        'senha': senha,
      }),
    );

    final dados = jsonDecode(response.body);
    return dados['mensagem'];
  }
}