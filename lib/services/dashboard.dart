import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardService {
  final String baseUrl = 'http://10.0.2.2:5000';

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}