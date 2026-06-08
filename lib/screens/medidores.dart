import 'package:flutter/material.dart';
import 'package:medidor_plus/screens/leituras.dart';
import '../services/medidor_service.dart';

class MedidorPage extends StatefulWidget {

  final int imovelId;
  final String imovelNome;


  const MedidorPage({
    required this.imovelId,
    required this.imovelNome,
    super.key
  });

  @override
  State<MedidorPage> createState() => _MedidorPageState();
}

class _MedidorPageState extends State<MedidorPage> {

  final _service = MedidoresService();
  final pesquisaCotroller = TextEditingController();
  List<dynamic> medidores = [];
  bool carregando = false;
  
  @override
  void initState(){
    super.initState();
    carregarMedidores();
  }

  Future<void> carregarMedidores({String pesquisa = ''})async{
    setState(()=> carregando  = true );
    final resultado = await _service.getMedidores(
      widget.imovelId,
      pesquisa: pesquisa
    );
    medidores = resultado;

    setState(() {
      carregando = false;
    });
  }

  void dialogCadastrar(){
    final unidadeController = TextEditingController();
    final identificador = TextEditingController();
    String tipoSelecionado = 'Água';

    showDialog(
      context: context, 
      builder: (context)=> StatefulBuilder(
        builder: (context, setStateDialog)=> AlertDialog(
          title: Text('Novo Medidor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: unidadeController,
                decoration: InputDecoration(
                  labelText: 'Unidade (ex: Ap 102, Kit 015)',
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 12,),
              TextField(
                controller: identificador,
                decoration: InputDecoration(
                  labelText: 'Identificador (número de série)' ,
                  border: OutlineInputBorder()
                ),
               
              ),
              SizedBox(height: 12,),
              DropdownButtonFormField<String>(
                initialValue: tipoSelecionado,
                items: [
                  DropdownMenuItem(value: 'Água', child: Text('Água')),
                  DropdownMenuItem(value: 'Energia', child: Text('Energia'))
                ], 
              onChanged: (value){
                setStateDialog(()=> tipoSelecionado = value!);
              })
            ],
          ),
          actions: [
            TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () async{
                final resposta = await _service.cadastrar( 
                  unidadeController.text, 
                  identificador.text, 
                  tipoSelecionado, 
                  widget.imovelId
                );
                if(!context.mounted) return;

                Navigator.pop(context);
                carregarMedidores();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(resposta['message']))
                );
              }, 
              child: Text('Salvar'))
          ],
        )));
  }

  void dialogEditar(dynamic medidor){
    final unidadeController = TextEditingController(text: medidor['unidade']);
    final identificador = TextEditingController(text: medidor['identificador']);

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Editar Medidor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: unidadeController,
              decoration: InputDecoration(
                labelText: 'Unidade',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 12,),
            TextField(
              controller: identificador,
              decoration: InputDecoration(
                labelText: 'Identificador',
                border: OutlineInputBorder()
              ),
            )
          ],
        ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
        ElevatedButton(
          onPressed: () async{
            final resposta = await _service.atualizar(
              medidor['id'],
              unidadeController.text,
              identificador.text
            );
            if(!context.mounted) return;

            Navigator.pop(context);
            carregarMedidores();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(resposta['message']))
            );
          }, 
          child: Text('Atualizar'))
      ],
      ));
  }

  void _dialogDeletar(dynamic medidor) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Remover Medidor'),
      content: Text('Deseja remover "${medidor['identificador']}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            final resposta = await _service.deletar(
              medidor['id']
            );
            if (!context.mounted) return;

            Navigator.pop(context);
            carregarMedidores();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Medidores - ${widget.imovelNome}'),
        backgroundColor: Color(0xFF0D1A63),
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
                  labelText: 'Pesquisar Medidores',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  suffixIcon: IconButton(onPressed: (){
                    pesquisaCotroller.clear();
                    carregarMedidores();
                  }, icon: Icon(Icons.clear))
                ),
                onSubmitted: (value) => carregarMedidores(pesquisa: value),
              ),
              ),
            Expanded(
              child: carregando ? Center(child: CircularProgressIndicator()) : medidores.isEmpty ? Center(child: Text('Nenhum medidor cadastrado')) :
              ListView.separated(
                itemCount: medidores.length,
                separatorBuilder: (context, index)=> Divider(),
                itemBuilder: (context, index){
                  final medidor = medidores[index];
                  final isAgua = medidor['tipo'] == 'Água';

                  return ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> LeiturasPage(medidorId: medidor['id'], medidorNome: medidor['unidade'])));
                    },

                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.edit, color: Colors.orange),
                              title: Text('Editar'),
                              onTap: () {
                                Navigator.pop(context);
                                dialogEditar(medidor);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Excluir'),
                              onTap: () {
                                Navigator.pop(context);
                                _dialogDeletar(medidor);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: isAgua
                          ? Colors.blue.shade50
                          : Colors.amber.shade50,
                      child: Icon(
                        isAgua ? Icons.water_drop_outlined : Icons.bolt,
                        color: isAgua ? Color(0xFF111FA2) : Colors.amber,
                      ),
                    ),
                    title: Text('${medidor['tipo']} · ${medidor['unidade']}'),
                    subtitle: Text('Ident.: ${medidor['identificador']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_right, color: Colors.blue,)
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