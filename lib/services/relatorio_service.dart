import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class RelatorioService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  final _authService = AuthService();

  Future<List<dynamic>> carregarOpcoes() async {
    final authHeaders = await _authService.authHeaders();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/relatorios/opcoes'),
        headers: authHeaders
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [{'success': false, 'message': 'Erro na consulta'}];
    }
  }

  Future<List<dynamic>> consumoPeriodo() async {
    final authHeaders = await _authService.authHeaders();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/relatorios/consumoPeriodo'),
        headers: authHeaders
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [{'success': false, 'message': 'Erro na consulta', 'erro': 'Erro: $e'}];
    }
  }
}