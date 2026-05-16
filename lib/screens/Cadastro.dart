import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  final auth_service = AutenticacaoService();
  final _formKey = GlobalKey<FormState>(); 
  final nameController = TextEditingController();
  final emailCadastroController = TextEditingController();
  final senhaCadastController = TextEditingController();
  final confirmSenhaController = TextEditingController();
  bool senhaVisivelCadastro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 60),
              Icon(Icons.water_drop, size: 80, color: Colors.blueAccent,),
              SizedBox(height: 16),
              Text(
                'Cadastro',
                style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_2_outlined),
                ),
                validator: (value){
                  if(value == null || value.isEmpty) return 'Insira o seu nome';
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: emailCadastroController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined)
                ),
                validator: (value){
                  if(value == null || value.isEmpty) return 'Por favor, digite seu um email';
                  if(!value.contains('@') || !value.contains('.')) return 'E-mail ivalido';
                  return null;
                },
              
              ),

              SizedBox(height: 8),

              TextFormField(
                controller: senhaCadastController,
                obscureText:!senhaVisivelCadastro,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_open_outlined),
                  suffixIcon: IconButton(onPressed: () {
                    setState(() => senhaVisivelCadastro = !senhaVisivelCadastro);
                  }, icon: Icon(senhaVisivelCadastro ? Icons.visibility : Icons.visibility_off))
                ),
                validator: (value){
                  if(value == null || value.isEmpty) return 'Por favor, digite uma senha';
                  if(value.length < 6) return 'A senha teve ter, no mínimo, 6 caractere';
                  return null;
                },
              ),

              SizedBox(height: 8),

              TextFormField(
                controller: confirmSenhaController,
                obscureText: !senhaVisivelCadastro,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(onPressed: (){
                    setState(() => senhaVisivelCadastro = !senhaVisivelCadastro);
                  }, icon: Icon(senhaVisivelCadastro ? Icons.visibility : Icons.visibility_off)),
                  
                ),
                validator: (value){
                  if(value == null || value.isEmpty) return 'Por favor, confirme sua senha';
                  if(value != senhaCadastController.text) return 'As senhas não coincidem';
                  return null;
                },
                
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async {
                  if (_formKey.currentState!.validate()) {
          // 2. chama a API
                  final mensagem = await auth_service.cadastrar(
                    nameController.text,
                    emailCadastroController.text,
                    confirmSenhaController.text,
                  );

                  // 3. exibe o retorno da API na tela
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(mensagem)),
                  );
                }
                }, child: Text('Cadastrar')),
              )
            ],
          ),
        )
      ),
    );
  }
}