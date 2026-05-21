import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailCadastroController = TextEditingController();
  final senhaCadastController = TextEditingController();
  final confirmSenhaController = TextEditingController();
  bool senhaVisivelCadastro = false;
  bool _carregando = false;

  Future<void> _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);

      final resposta = await authService.cadastrar(
        nameController.text,
        emailCadastroController.text,
        senhaCadastController.text,
      );

      setState(() => _carregando = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context,).showSnackBar(
        SnackBar(content: Text(resposta['message'])
      ));

      if (resposta['success'] == true) {
        Navigator.pop(context);

        for (final ctrl in [nameController, emailCadastroController, senhaCadastController, confirmSenhaController]) {
          ctrl.clear();
        }
      }
    }
  }

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
              Icon(Icons.water_drop, size: 80, color: Colors.blueAccent),
              SizedBox(height: 16),
              Text(
                'Cadastro',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_2_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Insira o seu nome';
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: emailCadastroController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, digite seu um email';
                  if (!value.contains('@') || !value.contains('.')) return 'E-mail ivalido';
                  return null;
                },
              ),

              SizedBox(height: 8),

              TextFormField(
                controller: senhaCadastController,
                obscureText: !senhaVisivelCadastro,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_open_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () => senhaVisivelCadastro = !senhaVisivelCadastro,
                      );
                    },
                    icon: Icon(
                      senhaVisivelCadastro
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, digite uma senha';
                  if (value.length < 6) return 'A senha teve ter, no mínimo, 6 caractere';
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () => senhaVisivelCadastro = !senhaVisivelCadastro,
                      );
                    },
                    icon: Icon(
                      senhaVisivelCadastro
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, confirme sua senha';
                  if (value != senhaCadastController.text) return 'As senhas não coincidem';
                  return null;
                },
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _carregando
                      ? null
                      : _cadastrar, // ← chama a função
                  child: _carregando
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
