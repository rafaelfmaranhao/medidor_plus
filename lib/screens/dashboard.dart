import 'package:flutter/material.dart';
import 'imoveis.dart';
import 'auth/login.dart';
import '../services/dashboard_service.dart';
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
  List<dynamic> _historico = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _getNome();
  }

  String nomeUsuario = '';

  Future<void> _getNome() async {
    final nome = await _authService.getNome();
    final historico = await _dashService.getHistorico();

    setState(() {
      nomeUsuario = nome ?? '';
      _historico = historico;
      _carregando = false;
    });
  }

  Future<void> _carregarDados() async {
    // final resposta = await _dashService.getDashboard();
    setState(() {
      // dados = resposta;
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
      margin: const EdgeInsets.fromLTRB(16,16,16,8),
      padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
      decoration: BoxDecoration(
        color: Color(0xFF111FA2),
        borderRadius: BorderRadius.circular(15)
        ,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $nomeUsuario!',
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
                    MaterialPageRoute(builder: (_) => LoginPage(),),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout, color: const Color.fromARGB(255, 255, 128, 126),),
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
              color: Color(0xFF53CBF3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF5478FF),
                  child: Icon(Icons.water_sharp, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(
                  'Consumo Água',
                  style: TextStyle(color: Color.fromARGB(255, 50, 86, 214), fontSize: 12),
                ),

                SizedBox(height: 8),

                Text(
                  'm³',
                  style: TextStyle(
                    color: Color.fromARGB(255, 50, 86, 214),
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
              color: Color(0xFF53CBF3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF5478FF),
                  child: Icon(Icons.energy_savings_leaf, color: Colors.white),
                ),
                Text(
                  'Consumo Luz',
                  style: TextStyle(color: Color.fromARGB(255, 50, 86, 214), fontSize: 12),
                ),

                SizedBox(height: 8),

                Text(
                  ' kWh',
                  style: TextStyle(
                    color: Color.fromARGB(255, 50, 86, 214),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImoveisPage(),));
        },
        label: Text('Imóveis'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFDE42),
          foregroundColor: Color(0xFF111FA2),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
      ),
    );
  }

  Widget historico() {
    if(_historico.isEmpty){
      return Center(child: Text('Nenhuma leitura registrada'));
    }
    return Column(
    children: _historico.map<Widget>((leitura) {  // ← adiciona <Widget>
      final isAgua = leitura['tipo'] == 'agua';

      return ListTile(
        leading: CircleAvatar(
          backgroundColor: isAgua
            ? Colors.blue.shade50
            : Colors.amber.shade50,
          child: Icon(
            isAgua ? Icons.water_drop_outlined : Icons.bolt,
            color: isAgua ? Color(0xFF111FA2) : Colors.amber,
          ),
        ),
        title: Text('${isAgua ? 'Água' : 'Energia'} - ${leitura['imovel']}'),
        subtitle: Text(leitura['data_leitura']),
        trailing: Text(
          '${leitura['leitura']} ${leitura['unidade']}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList(), // ← tem que ter o .toList() no final
  );
  }
}



