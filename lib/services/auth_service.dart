// services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:5000';

  Future<Map<String, dynamic>> cadastrar(
    String nome,
    String email,
    String senha,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cadastro'),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
        },
        body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
        encoding: Encoding.getByName('utf-8'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode({'email': email, 'senha': senha}),
      encoding: Encoding.getByName('utf-8'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await salvarToken(data['token'], data['usuario']['nome']);
    }

    return jsonDecode(response.body);
  }

  Future<void> salvarToken(String token, String nomeUsuario) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setString('nome', nomeUsuario);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  Future<String?> getNome() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('nome');
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('nome');
  }

  Future<bool> isLogged() async {
    final token = await getToken();

    return token != null;
  }

  Future<Map<String, String>> authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}
