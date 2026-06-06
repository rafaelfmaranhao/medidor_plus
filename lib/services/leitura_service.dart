import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medidor_plus/services/auth_service.dart';
import 'package:http/http.dart' as http;

class LeituraService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  final _authService = AuthService();

  Future<List<dynamic>> getLeituras(int medidorId, {String pesquisa = ''}) async {
    try {
      final authHeaders = await _authService.authHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/leituras?id=$medidorId&q=$pesquisa'),
        headers: authHeaders
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [{'success': false, 'message': 'Erro na consulta'}];
    }
  }

  Future<Map<String,dynamic>> cadastrar(
    String leitura,
    String dataLeitura,
    double valorTotal,
    int medidorId,
  ) async {
    try {
      final authHeaders = await _authService.authHeaders();

      final response = await http.post(
        Uri.parse('$baseUrl/leituras/cadastrar'),
        headers: authHeaders,
        body: jsonEncode({
          'leitura': leitura,
          'data_leitura': dataLeitura,
          'valor_total': valorTotal,
          'medidor_id': medidorId,
        }));
      return jsonDecode(response.body);
    } catch(e) {
      return {'success': false, 'message': 'Dados inválidos'};
    }
  }

  Future<Map<String, dynamic>> atualizar(
    int id,
    String leitura,
    String dataLeitura,
    double valorTotal,
  ) async {
    try {
      final authHeaders = await _authService.authHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/leituras/atualizar'),
        headers: authHeaders,
        body: jsonEncode({
          'id': id,
          'leitura': leitura,
          'data_leitura': dataLeitura,
          'valor_total': valorTotal,
        }),
      );
      return jsonDecode(response.body);
    } catch(e) {
      return{'success': false, 'message': 'Erro no endpoint'};
    }
  }

  Future<Map<String, dynamic>> deletar(int id)async{
    try {
      final authHeaders = await _authService.authHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/leituras/deletar'),
        headers: authHeaders,
        body: jsonEncode({'id': id}),
      );
      return jsonDecode(response.body);
    } catch(e) {
      return {'success': false,'message' : 'Erro no endpoint'};
    }
  }
}