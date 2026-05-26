import 'package:flutter/material.dart';
import '/screens/dashboard.dart';
import '/screens/imoveis.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int telaSeleceionada = 0;

  final List<Widget>_telas =[Dashboard(), ImoveisPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[telaSeleceionada],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: telaSeleceionada,
        onTap: (indice){
          setState(()=> telaSeleceionada = indice);
        },
        selectedItemColor: Color(0xFF2845D6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Imoveis')
        ],
      ),
    );
  }
}