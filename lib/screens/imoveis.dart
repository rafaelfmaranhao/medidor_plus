import 'package:flutter/material.dart';

import 'package:medidor_plus/screens/medidores.dart';
import 'package:medidor_plus/services/imovel_service.dart';


class ImoveisPage extends StatefulWidget {
  const ImoveisPage({super.key});

  @override
  State<ImoveisPage> createState() => _ImoveisPageState();
}

class _ImoveisPageState extends State<ImoveisPage> {

  final imovelservice = ImoveisService();
  final pesquisaCotroller = TextEditingController();
  List<dynamic> imoveis = [];
  bool carregando = false;

  @override

  void initState(){
    super.initState();
    carregarImoveis();
  }

  Future<void> carregarImoveis([String pesquisa = '']) async {
    setState(() => carregando = true );
    final resultado = await imovelservice.getImoveis(pesquisa);
    imoveis = resultado;

    if (!resultado[0]['success']) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Servidor offline')),
      );
      return;
    }

    setState(() {
      carregando = false;
    });
  }

  void dialogCadastrar(){
    final nomeController = TextEditingController();
    showDialog(context: context, builder: (context)=> 
    AlertDialog(
      title: Text('Novo Imóvel'),
      content: TextField(
        controller: nomeController,
        decoration: InputDecoration(
          labelText: 'Nome do imóvel',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancelar')),
        ElevatedButton(onPressed: ()async{
          final resposta = await imovelservice.cadastrar(nomeController.text);

          if (!context.mounted) return;

          Navigator.pop(context);
          carregarImoveis();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(resposta['message']))
          );
        }, child: Text('Salvar'))
      ],
    ));
  }

  void dialogEditar(int id, String nomeAtual){

    final nomeController = TextEditingController(text: nomeAtual);

    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text('Editar Imóvel'),
      content: TextField(
        controller: nomeController,
        decoration: InputDecoration(
          labelText: 'Nome do imovel',
          border: OutlineInputBorder(),
        ),
        
      ),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancelar')),
        ElevatedButton(onPressed: () async{
          final resposta = await imovelservice.atualizar(id, nomeController.text);

          if (!context.mounted) return;

          Navigator.pop(context);
          carregarImoveis();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(resposta['message']))
          );
        }, child: Text('Atualizar')),
      ],
    )
    );
  
  }

  void dialogDeletar(int id, String nome){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('Remover imovel'),
        content: Text('Deseja remover "$nome"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar')),
          ElevatedButton(
            onPressed: ()async{
              final resposta = await imovelservice.deletar(id);

              if (!context.mounted) return;

              Navigator.pop(context);
              carregarImoveis();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(resposta['message']))
              );
            }, 
            child: Text('Remover', style: TextStyle(color: Colors.white),))
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Imóveis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
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
                labelText: 'Pesquisar Imóveis',
                prefixIcon: Icon(Icons.search),
                
                suffixIcon: IconButton(
                  onPressed: (){
                    pesquisaCotroller.clear();
                    carregarImoveis();
                  }, 
                  icon: Icon(Icons.clear)
                )
              ),
              onChanged: (value)=> carregarImoveis(value),
            ),
          ),
          Expanded(child: carregando ? Center(child: CircularProgressIndicator()) :
            imoveis.isEmpty || imoveis[0]['nome'] == null ?
            Center(child: Text('Nenhum imovel cadastrado')) :

            ListView.separated(
              itemCount: imoveis.length, 
              separatorBuilder: (context, index)=> Divider(), 
              itemBuilder: (context, index){

                final imovel = imoveis[index];
                return ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> MedidorPage(imovelId: imovel['id'], imovelNome: imovel['nome'])));
                  },

                  onLongPress: (){
                    showModalBottomSheet(
                      context: context, 
                      builder: (context)=> Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.edit, color: Colors.orange,),
                            title: Text('Editar'),
                            onTap: (){
                              Navigator.pop(context);
                              dialogEditar(imovel['id'], imovel['nome']);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.delete, color: Colors.red,),
                            title: Text('Deletar'),
                            onTap: (){
                              Navigator.pop(context);
                              dialogEditar(imovel['id'], imovel['nome']);
                            },
                          ),
                        ],
                      ));
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50 ,
                    child: Icon(Icons.home, color: Colors.blue),
                  ),
                  title: Text(imovel['nome'], style: TextStyle(fontSize: 17),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chevron_right, color: Colors.blue,)
                    ],
                  ),
                );

              })
          )
        ],
      )
    );
  }
}