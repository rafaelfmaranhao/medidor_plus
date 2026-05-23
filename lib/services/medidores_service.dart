import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedidoresService {
  final String baseUrl = 'http://localhost:5000';

  Map<String, String> headerss(String token)=>{
    'Content-Tyle': 'application/json',
    'Authorization': 'Bearer $token',
  };
//get
  Future<List<dynamic>> getMedidores(String token, int imovelId, {String pesquisa = ''}) async{
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/medidores?id=$imovelId&q=$pesquisa'),
        headers: headerss(token)
      );
      return jsonDecode(response.body);
    }catch(e){
      return [];
    }
  }
//post
  Future<Map<String,dynamic>> cadastrar(
    String token,
    String unidade, 
    String identificador,
    String tipo,
    int fkimoveisId,
  )async{
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/medidores/cadastrar'),
        headers: headerss(token),
        body: jsonEncode(
          {
            'unidade': unidade,
            'identificador' : identificador,
            'tipo': tipo,
            'fk_imoceis_id': fkimoveisId,
            }
        )
      );
      return jsonDecode(response.body);
    }catch(e){
      return {'success': false, 'message': 'Erro: $e'};
    }
  }
//put
  Future<Map<String, dynamic>> atualizar(
    String token,
    int id,
    String unidade,
    String identificador,
  )async{
    try{
      final response = await http.put(
        Uri.parse('$baseUrl/medidores/atualizar'),
        headers: headerss(token),
        body: jsonEncode({
          'id': id,
          'unidade': unidade,
          'identificador': identificador
        })
      );
      return jsonDecode(response.body);
    }catch(e){
      return{'success': false, 'message': 'Erro: $e'};
    }
  }

  Future<Map<String, dynamic>> deletar(String token, int id)async{
    try{
      final response = await http.delete(
        Uri.parse('$baseUrl/medidores/deletar'),
        headers: headerss(token),
        body: jsonEncode({'id': id})
      );
      return jsonDecode(response.body);
    }catch(e){
      return {'success': false,'message' : 'Erro: $e'};
    }
  }
}