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
  Map<String, dynamic> _resultado = {};
  bool _carregando = false;
  bool _carregandoRelaorio = false;
  String _tipoRelatorio = 'consumo';

  dynamic _imovelSelecionado;
  dynamic _medidorSelecionado;

  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _now = DateTime.now();

  late DateTime? _dataInicial = DateTime(_now.year, _now.month, 1);
  late DateTime? _dataFinal = DateTime(_now.year, _now.month + 1, 0);

  @override
  void initState() {
    super.initState();
    _carregarOpcoes();
  }

  String formatarReais(double valor) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor);
  }

  Future<void> _carregarOpcoes() async {
    setState(() => _carregando = true);
    final opcoes = await _service.carregarOpcoes();

    setState(() {
      _opcoes = opcoes;
      _carregando = false;
    });
  }

  Future<void> _gerarRelatorio() async {
    if (_dataInicial == null || _dataFinal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione a data inicial e final')),
      );
      return;
    }

    setState(() => _carregandoRelaorio = true);

    try {
      final resultado = _tipoRelatorio == 'consumo'
          ? await _service.consumoPeriodo(
            dataInicial: _dateFormat.format(_dataInicial!),
            dataFinal: _dateFormat.format(_dataFinal!),
            imovelId: _imovelSelecionado?['id'],
            medidorId: _medidorSelecionado?['id'],
          )
          : await _service.totalPeriodo(
            dataInicial: _dateFormat.format(_dataInicial!),
            dataFinal: _dateFormat.format(_dataFinal!),
            imovelId: _imovelSelecionado?['id'],
            medidorId: _medidorSelecionado?['id'],
          );

      setState(() {
        _resultado = resultado;
        _carregandoRelaorio = false;
      });
    } catch (e) {
      setState(() => _carregandoRelaorio = false);
    }
  }

  Future<void> _selecionarData(bool isInicial) async {
    final data = await showDatePicker(
      context: context,
      initialDate: isInicial ? _dataInicial! : _dataFinal!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        backgroundColor: Color(0xFF0D1A63),
        foregroundColor: Colors.white,
      ),
      body: _carregando
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipo de Relatório',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  initialValue: _tipoRelatorio,
                  items: const [
                    DropdownMenuItem(
                      value: 'consumo',
                      child: Text('Consumo por Periódo'),
                    ),
                    DropdownMenuItem(
                      value: 'total',
                      child: Text('Valor Total por Periódo'),
                    ),
                  ],
                  onChanged: (value) {
                    _tipoRelatorio = value!;
                  },
                ),
                SizedBox(height: 4),
                Text(
                  'Selecione o periodo e os filtros',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),

                Text('Imóvel', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField(
                  items: [
                    DropdownMenuItem(child: Text('Todos os imóveis')),
                    ..._opcoes.map(
                      (imovel) => DropdownMenuItem(
                        value: imovel,
                        child: Text(imovel['nome'] ?? ''),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    _imovelSelecionado = value;
                    setState(() => _medidorSelecionado = null);
                  },
                ),
                SizedBox(height: 16),

                if (_imovelSelecionado != null) ...[
                  Text(
                    'Medidor',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<dynamic>(
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Todos os medidores'),
                      ),
                      ...(_imovelSelecionado['medidores'] as List).map(
                        (medidor) => DropdownMenuItem(
                          value: medidor,
                          child: Text(
                            '${medidor['tipo']} (${medidor['unidade']})',
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      _medidorSelecionado = value;
                    },
                  ),
                  SizedBox(height: 16),
                ],

                Text(
                  'Período',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selecionarData(true),
                        child: Container(
                          padding: EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Data Inicial', style: TextStyle(color: Colors.grey),),
                                  Text(
                                    _dateFormat.format(_dataInicial!),
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selecionarData(false),
                        child: Container(
                          padding: EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Data Final', style: TextStyle(color: Colors.grey),),
                                  Text(
                                    _dataFinal != null
                                        ? _dateFormat.format(_dataFinal!)
                                        : _dateFormat.format(DateTime(_now.year, _now.month + 1, 0)),
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _carregandoRelaorio ? null : _gerarRelatorio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0D1A63),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _carregandoRelaorio
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Gerar Relatorio'),
                  ),
                ),
                SizedBox(height: 24),

                if (_resultado.isNotEmpty) ...[
                  Text(
                    'Resultado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10,),
                    decoration: BoxDecoration(
                      color: Color(0xFF0D1A62),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              _tipoRelatorio == 'consumo'
                                  ? 'Consumo Total por Período'
                                  : 'Valor Total por Período',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 40),
                          ],
                        ),

                        SizedBox(height: 10),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  _tipoRelatorio == 'consumo'
                                      ? 'Consumo Água'
                                      : 'Total Água',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _tipoRelatorio == 'consumo'
                                      ? '${_resultado['consumo_agua'] ?? 0} m³'
                                      : formatarReais(double.parse(_resultado['total_agua'] ?? '0.0')),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  _tipoRelatorio == 'consumo'
                                      ? 'Consumo Energia'
                                      : 'Total Energia',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _tipoRelatorio == 'consumo'
                                      ? '${_resultado['consumo_energia'] ?? 0} kWh'
                                      : formatarReais(double.parse(_resultado['total_energia'] ?? '0.0')),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          _medidorSelecionado != null
                              ? _medidorSelecionado['unidade']
                              : '',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
    );
  }
}
