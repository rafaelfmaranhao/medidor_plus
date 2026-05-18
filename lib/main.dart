import 'package:flutter/material.dart';
import 'package:medidor_plus/screens/dashboard.dart';
import 'package:medidor_plus/screens/imoveis.dart';
import 'screens/login.dart';
import 'screens/imoveis.dart';

void main() {
  runApp(MaterialApp(home: ImoveisPage(token: 'meu token teste',)));
}