import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http; // <-- Faltava essa linha!


class ImoveisService{
  final String baseUrl = 'http://10.0.2.2:5000';

  Map<String, String>_headers(String token) =>{
    'Content-Type' : 'application/json',
    'Authorization': 'Bearer $token'
  };
//lista os imoveis
  Future<List<dynamic>> getImoveis(String token, {String pesquisa = ''})async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/imoveis?q=$pesquisa'),
        headers: _headers(token),
        
      );
      return jsonDecode(response.body);
    }catch (e){
      return [];
    } 
    }
//cadastrar imoveis
  Future<Map<String, dynamic>> cadastrar(String token, String nome) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/imoveis/cadastrar'),
        headers: _headers(token),
        body: jsonEncode({'nome' : nome}),
      );
      return jsonDecode(response.body);
    }catch(e){
      return {'success': false, 'message': 'Erro: $e'};
    }
  }
//atualizaar imoveis
  Future<Map<String, dynamic>> atualizar(String token, int id, String nome)async {
    try{
      final response = await http.put(
        Uri.parse('$baseUrl/imoveis/atualizar'),
        headers: _headers(token),
        body: jsonEncode({'id': id, 'nome': nome}),
      );
      return jsonDecode(response.body);

    }catch(e){
      return {'success':false,'message':'Erro:$e'};
    }
  }
  Future<Map<String, dynamic>>deletar(String token, int id) async{
    try{
      final response = await http.delete(
        Uri.parse('$baseUrl/imoveis/deletar'),
        headers: _headers(token),
        body: jsonEncode({'id': id}),
      );
    return jsonDecode(response.body);
    }catch(e){
    return {'success': false, 'message': 'Erro: $e'};
  }
  }
}