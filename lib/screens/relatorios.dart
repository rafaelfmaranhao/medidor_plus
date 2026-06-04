import 'package:flutter/material.dart';
import '../services/relatorio_service.dart';
import 'package:intl/intl.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  final _service = RelatorioService();

  List<dynamic> _opcoes = [];
  List<dynamic> _resultado = [];
  bool _carregando = false;
  bool _carregandoRelaorio = false;

  dynamic _imovelSelecionado = null;
  dynamic _medidorSelecionado = null;

  DateTime? _dataInicial;
  DateTime? _dataFinal;

  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState(){
    super.initState();
    _carregarOpcoes();
  }

  Future<void> _carregarOpcoes() async{
    setState(() => _carregando = true);
    final opcoes = await _service.carregarOpcoes();
    setState(() {
      _opcoes = opcoes;
      _carregando = false;
    });
  }

  Future<void> _gerarRelatorio() async {
    if(_dataFinal == null || _dataFinal == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione a data inicial e final'))
      );
      return;
    }
    setState(() => _carregandoRelaorio = true);
    final resultado = await _service.consumoPeriodo(
      dataIncial: _dateFormat.format(_dataInicial!),
      dataFinal:   _dateFormat.format(_dataFinal!),
      imovelId:    _imovelSelecionado?['id']?.toString(),
      medidorId:   _medidorSelecionado?['id']?.toString(),
    );
    setState(() {
      _resultado = resultado;
      _carregandoRelaorio = false;
    });
  }

  Future<void> _selecionarData(bool isInicial) async {
    final data = await showDatePicker(
      context:     context,
      initialDate: DateTime.now(),
      firstDate:   DateTime(2000),
      lastDate:    DateTime(2100),
    );

    if (data == null) return;

    setState(() {
      if (isInicial) {
        _dataInicial = data;
      } else {
        _dataFinal = data;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        backgroundColor: Color(0xFF0D1A63),
        foregroundColor: Colors.white,
      ),
      body: _carregando ? Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Relatório de Consumo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Selecione o periodo e os filtros',
              style: TextStyle(color: Colors.grey) ,
            ),
            SizedBox(height: 24),

            Text('Imóvel', style: TextStyle( fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButtonFormField(items: [
              DropdownMenuItem(child: Text('Todos os imóveis')),
              ..._opcoes.map((imovel) => DropdownMenuItem(child: Text(imovel['nome']), value: imovel,))
            ], onChanged: (value){
              setState(() {
                _imovelSelecionado = value;
                _medidorSelecionado = null;
              });
            }),
            SizedBox(height: 16),
            if(_imovelSelecionado !=  null) ...[
              Text('Medidor', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<dynamic>(
                items: [
                  DropdownMenuItem(
                    value: null, child: Text('Todos os medidores')),
                      ...(_imovelSelecionado['medidores'] as List).map((medidor) =>
                        DropdownMenuItem(
                          value: medidor,
                          child: Text('${medidor['tipo']} (${medidor['unidade']})'),
                        ),)
                ], 
                onChanged: (value){
                  setState(() => _medidorSelecionado = value);
                },
                ),
                SizedBox(height: 16)  
            ],
            Text('Período', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8,),
            Row(
              children: [
                Expanded(child: GestureDetector(
                  onTap: ()=> _selecionarData(true),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          _dataInicial != null ? _dateFormat.format(_dataInicial!) : 'Data inicial',
                          style: TextStyle(
                            color: _dataInicial != null ? Colors.black : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
                SizedBox(width: 12),
                Expanded(child: GestureDetector(
                  onTap: () => _selecionarData(false),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey,),
                        SizedBox(width: 8,),
                        Text(
                          _dataFinal != null ? _dateFormat.format(_dataFinal!) : 'Data Final',
                          style: TextStyle(
                            color: _dataFinal != null ? Colors.black : Colors.grey
                          ),
                        )
                      ],
                    ),
                  ),
                  
                ))
              ],
            ),
            SizedBox(height: 24,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _carregandoRelaorio ? null : _gerarRelatorio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0D1A63),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16) 
              ),
              child: _carregandoRelaorio ? CircularProgressIndicator(color: Colors.white ,) : Text('Gerar Relatorio')),
            ),
            SizedBox(height: 24,),
            if(_resultado.isNotEmpty)...[
              Text('Resultado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 12,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF0D1A62),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Icon(Icons.bar_chart, color: Colors.white, size: 40,),
                    SizedBox(height: 8,),
                    Text(
                      'Total de Consumo',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4,),
                    Text(
                      '${_resultado[0]['total_leitura'] ?? 0}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      _medidorSelecionado != null ? _medidorSelecionado['unidade']: 'unidade', style: TextStyle(color: Colors.white70),
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}