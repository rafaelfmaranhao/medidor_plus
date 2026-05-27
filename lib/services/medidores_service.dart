import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/services/auth_service.dart';

class MedidoresService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  final _authService = AuthService();


  Future<List<dynamic>> getMedidores(int imovelId, {String pesquisa = ''}) async{
    try{
      final authHeaders = await _authService.authHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/medidores?id=$imovelId&q=$pesquisa'),
        headers: authHeaders,);
      return jsonDecode(response.body);
    }catch(e){
      return [{'success': false, 'message': 'Erro: $e'}];
    }
  }
//post
  Future<Map<String,dynamic>> cadastrar(
    String unidade,
    String identificador,
    String tipo,
    int fkImoveisId,
  )async{
    try{
      final authHeaders = await _authService.authHeaders();

      print('Enviando: unidade=$unidade, identificador=$identificador, tipo=$tipo, imovelId=$fkImoveisId'); // ← aqui


      final response = await http.post(
        Uri.parse('$baseUrl/medidores/cadastrar'),
        headers: authHeaders,
        body: jsonEncode({
          'unidade':       unidade,
          'identificador': identificador,
          'tipo':          tipo,
          'fk_imoveis_id': fkImoveisId,
        }));
      return jsonDecode(response.body);
    }catch(e){
      return {'success': false, 'message': 'Erro: $e'};
    }
  }
//put
  Future<Map<String, dynamic>> atualizar(
    int id,
    String unidade,
    String identificador,
  )async{
    try{
      final authHeaders = await _authService.authHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/medidores/atualizar'),
        headers: authHeaders,
        body: jsonEncode({
          'id':            id,
          'unidade':       unidade,
          'identificador': identificador,
        }),
      );
      return jsonDecode(response.body);
    }catch(e){
      return{'success': false, 'message': 'Erro: $e'};
    }
  }

  Future<Map<String, dynamic>> deletar(int id)async{
    try{
      final authHeaders = await _authService.authHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/medidores/deletar'),
        headers: authHeaders,
        body: jsonEncode({'id': id}),
      );
      return jsonDecode(response.body);
    }catch(e){
      return {'success': false,'message' : 'Erro: $e'};
    }
  }
}