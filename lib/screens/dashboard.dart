import 'package:flutter/material.dart';
import 'imoveis.dart';
import 'auth/login.dart';
import '../services/dashboard_service.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';
import '../screens/relatorios.dart';

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

  String formatarReais(double valor) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    ).format(valor);
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
    final resposta = await _dashService.getDashboard();
    dados = resposta;
    setState(() {
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),

            _buildHeader(),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  criarCards(),
                  SizedBox(height: 24),
                  btnAdd(context),
                  SizedBox(height: 12),      // ← espaçamento entre os botões
                  btnRelatorios(context),    // ← adiciona essa linha
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
                'Medidor+',
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
    final totalAgua    = dados['total_agua']?.toString()    ?? '0';
    final totalEnergia = dados['total_energia']?.toString() ?? '0';
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 207, 211, 234),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 50, 86, 214),
                  child: Icon(Icons.water_sharp, color: Colors.white),
                ),

                SizedBox(height: 8,),

                Text(
                  'Total Água',
                  style: TextStyle(color: Color.fromARGB(255, 50, 86, 214), fontSize: 14),
                ),

                SizedBox(height: 5),

                Text(
                  formatarReais(double.parse(totalAgua)),
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
              color: Color.fromARGB(255, 250, 228, 175),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 160, 59),
                  child: Icon(Icons.energy_savings_leaf, color: Colors.white),
                ),

                SizedBox(height: 8,),

                Text(
                  'Total Energia',
                  style: TextStyle(color: const Color.fromARGB(255, 255, 160, 59), fontSize: 14),
                ),

                SizedBox(height: 5),

                Text(
                  formatarReais(double.parse(totalEnergia)),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 160, 59),
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
        label: Text('Imóveis', style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D1A63),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
      ),
    );
  }

   Widget btnRelatorios(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RelatoriosPage(),));
        },
        label: Text('Relatórios', style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D1A63),
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
      children: _historico.map<Widget>((leitura) {// ← adiciona <Widget>
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



