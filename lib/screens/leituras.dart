import 'package:flutter/material.dart';
import 'package:medidor_plus/services/leitura_service.dart';

class LeiturasPage extends StatefulWidget {

  final int medidorId;
  final String medidorNome;

  const LeiturasPage({
    required this.medidorId,
    required this.medidorNome,
    super.key
  });

  @override
  State<LeiturasPage> createState() => _LeiturasPageState();
}

class _LeiturasPageState extends State<LeiturasPage> {
  final _service = LeituraService();
  final pesquisaCotroller = TextEditingController();
  List<dynamic> leituras = [];
  bool carregando = false;

  @override
  void initState(){
    super.initState();
    getLeituras();
  }

  Future<void> getLeituras({String pesquisa = ''}) async {
    setState(()=> carregando  = true );
    final resultado = await _service.getLeituras(
        widget.medidorId,
        pesquisa: pesquisa
    );

    setState(() {
      leituras = resultado;
      carregando = false;
    });
  }

  void dialogCadastrar(){
    final leituraController = TextEditingController();
    final dataLeituraCtrl = TextEditingController();
    final valorTotal = TextEditingController();

    showDialog(
      context: context,
      builder: (context)=> StatefulBuilder(
        builder: (context, setStateDialog)=> AlertDialog(
          title: Text('Registrar Leitura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: leituraController,
                decoration: InputDecoration(
                  labelText: 'Leitura',
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 12,),
              TextField(
                controller: dataLeituraCtrl,
                decoration: InputDecoration(
                  labelText: 'Data Leitura' ,
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 12,),
              TextField(
                controller: valorTotal,
                decoration: InputDecoration(
                    labelText: 'Valor Total' ,
                    border: OutlineInputBorder()
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                final resposta = await _service.cadastrar(
                  leituraController.text,
                  dataLeituraCtrl.text,
                  double.parse(valorTotal.text),
                  widget.medidorId
                );
                if(!mounted) return;

                Navigator.pop(context);
                getLeituras();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(resposta['message']))
                );
              },
              child: Text('Salvar')
            )
          ],
        )
      )
    );
  }
  void dialogEditar(dynamic leitura){
    final leituraController = TextEditingController();
    final dataLeituraCtrl = TextEditingController();
    final valorTotal = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Leitura'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: leituraController,
              decoration: InputDecoration(
                  labelText: 'Leitura',
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 12,),
            TextField(
              controller: dataLeituraCtrl,
              decoration: InputDecoration(
                  labelText: 'Data Leitura',
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 12,),
            TextField(
              controller: valorTotal,
              decoration: InputDecoration(
                  labelText: 'Valor Total' ,
                  border: OutlineInputBorder()
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
            getLeituras();
          }, child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () async{
              final resposta = await _service.atualizar(
                leitura['id'],
                leituraController.text,
                dataLeituraCtrl.text,
                double.parse(valorTotal.text)
              );
              if(!mounted) return;
              Navigator.pop(context);
              getLeituras();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(resposta['message']))
              );
            },
            child: Text('Atualizar'))
        ],
      )
    );
  }

  void _dialogDeletar(dynamic leitura) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remover Leitura'),
        content: Text('Deseja remover essa leitura? (${leitura['leitura']}, ${leitura['data_leitura']})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final resposta = await _service.deletar(
                  leitura['id']
              );
              if (!mounted) return;
              Navigator.pop(context);
              getLeituras();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(resposta['message'])),
              );
            },
            child: Text('Remover', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leituras - ${widget.medidorNome}'),
        backgroundColor: Color(0xFFFF0D1A63),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: dialogCadastrar,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white,),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: pesquisaCotroller,
              decoration: InputDecoration(
                labelText: 'Pesquisar Medidor',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                suffixIcon: IconButton(onPressed: (){
                  pesquisaCotroller.clear();
                  getLeituras();
                }, icon: Icon(Icons.clear))
              ),
              onChanged: (value) => getLeituras(pesquisa: value),
            ),
          ),
          Expanded(
            child: carregando ? Center(child: CircularProgressIndicator()) :
            leituras.isEmpty ? Center(child: Text('Nenhuma leitura cadastrado')) :
            ListView.separated(
              itemCount: leituras.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index){
                final leitura = leituras[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      Icons.receipt,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(leitura['leitura']),
                  subtitle: Text('${leitura['data_leitura']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: ()=> dialogEditar(leitura), icon: Icon(Icons.edit), color: Colors.orange,),
                      IconButton(onPressed: ()=> _dialogDeletar(leitura), icon: Icon(Icons.delete), color: Colors.red)
                    ],
                  ),
                );
              },
            )
          )
        ],
      ),
    );
  }
}
