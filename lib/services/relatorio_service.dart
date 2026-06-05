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

  Future<Map<String, dynamic>> consumoPeriodo({
    required String dataInicial,
    required String dataFinal,
    int? imovelId,
    int? medidorId
  }) async {
    final authHeaders = await _authService.authHeaders();

    String url = "$baseUrl/relatorios/consumoPeriodo?data_inicial=$dataInicial&data_final=$dataFinal";
    if (imovelId != null) url += '&imovel=$imovelId';
    if  (medidorId != null) url += '&medidor=$medidorId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: authHeaders
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Erro na consulta', 'erro': 'Erro: $e'};
    }
  }

  Future<Map<String, dynamic>> totalPeriodo({
    required String dataInicial,
    required String dataFinal,
    int? imovelId,
    int? medidorId
  }) async {
    final authHeaders = await _authService.authHeaders();

    String url = "$baseUrl/relatorios/totalPeriodo?data_inicial=$dataInicial&data_final=$dataFinal";
    if (imovelId != null) url += '&imovel=$imovelId';
    if (medidorId != null) url += '&medidor=$medidorId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: authHeaders
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Erro na consulta', 'erro': 'Erro: $e'};
    }
  }
}
