import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DB.dart';

class NovaConta extends StatefulWidget {
  @override
  _NovaConta createState() => _NovaConta();
}

class _NovaConta extends State<NovaConta> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool valid = false;

  String erro = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Usuário"),
      ),
      body: Form(
        //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
        key: _formKey, //estado do formulário
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Login:", hintText: "Digite o login"),
              controller: _controllerLogin,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o texto";
                }
                if(!this.valid)
                  return "Usuário já cadastrado.";

                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Senha:", hintText: "Digite a senha"),
              obscureText: true,
              controller: _controllerSenha,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite a senha ";
                }
                if (text.length < 4) {
                  return "A senha tem pelo menos 4 dígitos";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text(
                    "Criar usuário",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    bool p = await check_user(_controllerLogin.text);
                    bool formOk = _formKey.currentState.validate();

                    if (!formOk || p  ) {
                      return;
                    } else {
                      DB.salvar_conta(
                          _controllerLogin.text, _controllerSenha.text);
                    }
                    print("Login " + _controllerLogin.text);
                    print("Senha " + _controllerSenha.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  check_user(String text) async {
    if (await DB.verificarUserBD(text)) {
      print("VERIFICOU USER EXISTE");
      setState(() {
        this.valid = false;
      });
      return true;
    } else {
      print("VERIFICOU USER NAO EXISTE");
      setState(() {
        this.valid = true;
      });
      return false;
    }
  }
}
