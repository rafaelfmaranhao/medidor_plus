import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:medidor_plus/services/auth_service.dart';


class ImoveisService{
  final String baseUrl = 'http://localhost:5000';
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
      print(e);
      return [];
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