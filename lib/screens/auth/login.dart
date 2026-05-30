import 'package:flutter/material.dart';
import 'package:medidor_plus/screens/auth/recuperar_senha.dart';
import 'cadastro.dart';
import '/screens/bottom.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool senhaVisivel = false;

  Future<void> _login() async {
    final response = await authService.login(emailController.text, senhaController.text);

    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      if (response['success'] == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Bottom()));

        for (final ctrl in [emailController, senhaController]) {
          ctrl.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 0),
              Image.asset('assets/imagens/logoMedidor.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain ),
              Text(
                'Bem-vindo!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Faça Login para continuar',
                style: TextStyle(fontSize: 10,),
              ),
            
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(83, 203, 243, 1),
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(12)
                  ),

                ),
              ),

              SizedBox(height: 16,),

              TextFormField(
                controller: senhaController,
                obscureText: !senhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(onPressed: () {
                    setState(() => senhaVisivel = !senhaVisivel);
                  }, icon: Icon(senhaVisivel ? Icons.visibility : Icons.visibility_off)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:  Color.fromRGBO(83, 203, 243, 1),
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
              
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => RecuperarSenha()));
                  },
                  child: Text('Esqueci minha senha')
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async {
                  _login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF111FA2),
                  foregroundColor: Colors.white
                ),
                child: Text('Entrar')),
                
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Não tem conta?'),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroPage()));
                  }, child: Text('Cadastre-se'))
                ],
              ),
            ]
          )
        ),
      ),
    );
  }
}