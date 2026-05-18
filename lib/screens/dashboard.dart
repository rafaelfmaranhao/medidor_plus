import 'package:flutter/material.dart';
import 'package:medidor_plus/screens/login.dart';
import '../services/dashboard.dart';
import '../services/auth_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _dashService = DashboardService();
  final _authService = AuthService();

  Map<String, dynamic> dados = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final resposta = await _dashService.getDashboard();
    setState(() {
      dados = resposta;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  criarCards(),
                  SizedBox(height: 24),
                  btnAdd(context),
                  SizedBox(height: 24),
                  Text(
                    'Histórico',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  historico(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 56, 16, 24),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 51, 73, 114),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, Bem-vindo!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Seu controle doméstico',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              Text('Sair', style: TextStyle(color: Colors.white, fontSize: 15),),
              IconButton(
                onPressed: () {
                  _authService.logout();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout, color: Colors.white,),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget criarCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.water_sharp, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(
                  'Consulmo Água',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

                SizedBox(height: 8),

                Text(
                  'dados da agua',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.energy_savings_leaf, color: Colors.white),
                ),
                Text(
                  'Consumo Luz',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

                SizedBox(height: 8),

                Text(
                  'detalhes da energia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget btnAdd(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, 'nova-leitura');
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Novo Registro'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
      ),
    );
  }

  Widget historico() {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.water_drop, color: Colors.blue),
          ),
          title: Text('Água - Leitura'),
          subtitle: Text('Out'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Agua', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}



