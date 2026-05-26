import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '/services/auth_service.dart';


class ImoveisService{
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  final _authService = AuthService();

  Future<List<dynamic>> getImoveis([String pesquisa = ''])async {
    try {
      final authHeaders = await _authService.authHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/imoveis?q=$pesquisa'),
        headers: authHeaders,
      );

      return jsonDecode(response.body);
    }catch (e){
      return [{'success': false, 'message': 'Erro: $e'}];
    } 
  }

  Future<Map<String, dynamic>> cadastrar(String nome) async {
    try{
      final authHeaders = await _authService.authHeaders();

      final response = await http.post(
        Uri.parse('$baseUrl/imoveis/cadastrar'),
        headers: authHeaders,
        body: jsonEncode({'nome' : nome}),
      );
      return jsonDecode(response.body);
    }catch(e){
      return {'success': false, 'message': 'Erro: $e'};
    }
  }

  Future<Map<String, dynamic>> atualizar(int id, String nome)async {
    try{
      final authHeaders = await _authService.authHeaders();

      final response = await http.put(
        Uri.parse('$baseUrl/imoveis/atualizar'),
        headers: authHeaders,
        body: jsonEncode({'id': id, 'nome': nome}),
      );
      return jsonDecode(response.body);

    }catch(e){
      return {'success':false,'message':'Erro:$e'};
    }
  }

  Future<Map<String, dynamic>>deletar(int id) async{
    try{
      final authHeaders = await _authService.authHeaders();

      final response = await http.delete(
        Uri.parse('$baseUrl/imoveis/deletar'),
        headers: authHeaders,
        body: jsonEncode({'id': id}),
      );
    return jsonDecode(response.body);
    }catch(e){
    return {'success': false, 'message': 'Erro: $e'};
  }
  }
}