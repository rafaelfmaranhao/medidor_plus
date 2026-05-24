import 'package:flutter/material.dart';
import '/services/auth_service.dart';

class RecuperarSenha extends StatefulWidget {
  const RecuperarSenha({super.key});

  @override
  State<RecuperarSenha> createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {

  final _authService = AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController novaSenhaController = TextEditingController();
  TextEditingController codigoRecController = TextEditingController();

  bool codigoEnviado = false;
  bool codigoValidado = false;
  bool senhaVisivel = false;

  Future<Map<String, dynamic>> _recuperarSenha(String email) async {
    final response = await _authService.recuperarSenha(email);

    if (response['success']) {
      setState(() {
        codigoEnviado = true;
      });
    }

    return response;
  }

  Future<Map<String, dynamic>> _validarCodigo(int codigo) async {
    final response = await _authService.validarCodigo(codigo);

    if (response['success']) {
      setState(() {
        codigoValidado = true;
      });
    }

    return response;
  }

  Future<Map<String, dynamic>> _atualizarSenha() async {
    String email = emailController.text;
    String novaSenha = novaSenhaController.text;

    final response = await _authService.atualizarSenha(email, novaSenha);
    if (response['success']) {
      if (!mounted) {
        return {'success': false, 'message': 'Erro na interface, tente novamente'};
      }

      Navigator.of(context).pop();
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    String titulo = 'Recupere sua Senha';
    String descricao = 'Digite seu E-mail cadastrado para receber um código';
    String textoBotao = 'Enviar';

    if (codigoEnviado && !codigoValidado) {
      titulo = 'Confirmar Código';
      descricao = 'Confirme o código enviado para o seu e-mail';
      textoBotao = 'Confirmar';
    }

    if (codigoValidado) {
      titulo = 'Nova Senha';
      descricao = 'Digite sua nova senha';
      textoBotao = 'Alterar Senha';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Senha'),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                titulo,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12,),
              Text(descricao),
              SizedBox(height: 30),

              if (!codigoEnviado)
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail Cadastrado',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

              if (codigoEnviado && !codigoValidado)
                TextFormField(
                  controller: codigoRecController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Código de Confirmação',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

              if (codigoValidado)
                TextFormField(
                  controller: novaSenhaController,
                  obscureText: !senhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(onPressed: () {
                      setState(() => senhaVisivel = !senhaVisivel);
                    }, icon: Icon(senhaVisivel ? Icons.visibility : Icons.visibility_off))
                  ),
                ),

              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);

                  if (!codigoEnviado) {
                    final response = await _recuperarSenha(emailController.text);

                    messenger.showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  } else if (!codigoValidado) {
                    int? codigo = int.tryParse(codigoRecController.text);

                    if (codigo != null) {
                      final response = await _validarCodigo(codigo);

                      messenger.showSnackBar(
                        SnackBar(content: Text(response['message'])),
                      );
                    }
                  } else {
                    final response = await _atualizarSenha();

                    messenger.showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white
                ),
                child: Text(textoBotao)),
              ),
            ]
          )
        ),
      ),
    );
  }
}
