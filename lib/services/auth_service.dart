// services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000';

  Future<String> cadastrar(String nome, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cadastro'),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json'
      },
      body: jsonEncode({
        'nome':  nome,
        'email': email,
        'senha': senha,
      }),
      encoding: Encoding.getByName('utf-8')
    );

    final dados = jsonDecode(response.body);
    return dados['message'];
  }

  Future<String> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json'
      },
      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
      encoding: Encoding.getByName('utf-8')
    );
    
    final dados = jsonDecode(response.body);
    return dados['message'];
  }

  Future logout() async {
    
  }
}