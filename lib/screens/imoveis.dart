import 'package:flutter/material.dart';
import 'package:medidor_plus/services/imoveisServices.dart';

class ImoveisPage extends StatefulWidget {

  final String token;
  const ImoveisPage({required this.token,super.key});
  

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
  Future<void>carregarImoveis([String pesquisa = ''])async {
    setState(() =>carregando =true );
    final resultadopesquisa = await imovelservice.getImoveis(widget.token, pesquisa: pesquisa);
    setState(() {
      imoveis = resultadopesquisa;
      carregando = false;
    });

  }

//alert para cadastrar
  void dialogCadastrar(){
    final nomeController = TextEditingController();
    showDialog(context: context, builder: (context)=> 
    AlertDialog(
      title: Text('Novo Imovel'),
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
          final resposta = await imovelservice.cadastrar(widget.token, nomeController.text);
          Navigator.pop(context);
          carregarImoveis();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(resposta['message']))
          );
        }, child: Text('Salvar'))
      ],
    ));
  }
//alert para editar

  void dialogEditar(int id, String nomeAtual){

    final nomeController = TextEditingController(text: nomeAtual);

    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text('Editar Imovel'),
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
          final resposta = await imovelservice.atualizar(widget.token, id, nomeController.text);
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

//delete

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
              final resposta = await imovelservice.deletar(widget.token, id);
              carregarImoveis();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resposta['message'])));
            }, 
            child: Text('Remover', style: TextStyle(color: Colors.white),))
        ],
      ));
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Imoveis'),
        backgroundColor: Color(0xFF1A2B4A),
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
                labelText: 'Pesquisar Imovel',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
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
          Expanded(child: carregando ? Center(child: CircularProgressIndicator()) : imoveis.isEmpty ?Center(
            child: Text('Nenhum imovel cadastrado')): ListView.separated(

              itemCount: imoveis.length, 
              separatorBuilder: (context, index)=> Divider(), 
              itemBuilder: (context, index){

                final imovel = imoveis[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50 ,
                    child: Icon(Icons.home, color: Colors.blue),
                  ),
                  title: Text(imovel['nome']),
                  subtitle: Text('ID: ${imovel['id']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: ()=> dialogEditar(imovel['id'], imovel['nome']),
                        icon: Icon(Icons.edit, color: Colors.amber,)
                      ),
                      IconButton(
                        onPressed: ()=> dialogDeletar(imovel['id'], imovel['nome']), 
                        icon: Icon(Icons.delete, color: Colors.redAccent,))
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