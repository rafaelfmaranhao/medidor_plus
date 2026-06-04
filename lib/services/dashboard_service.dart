import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';

class DashboardService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  final _authService = AuthService();

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final authHeaders = await AuthService().authHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: authHeaders,
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

    Future<List<dynamic>> getHistorico() async {
    try {
      final authHeaders = await _authService.authHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/historico'),
        headers: authHeaders,
      );

      final decoded = jsonDecode(response.body);
      if (decoded is Map) return [];
      return decoded;
    } catch (e) {
      return [];
    }
  }

}