import 'package:agendacont_app/novaconta.dart';
import 'package:flutter/material.dart';
import 'lista.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class PaginaLogin extends StatefulWidget {
  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validp = false;
  bool valids = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos App"),
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
                } else {
                  //check_user(text);
                  //while(this.loading);
                  if (!this.validp) {
                    return "User não existe";
                  }
                }

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

                if (this.validp && !this.valids) {
                  return "Senha incorreta";
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
                    "Login",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    bool p = await check_user(_controllerLogin.text);
                    bool s = await check_login(_controllerLogin.text, _controllerSenha.text);
                    bool formOk = _formKey.currentState.validate();


                    if (!formOk || !s ) {
                      print("aqui");
                      return;
                    } else {
                      print("FORM OK");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext) => Lista(_controllerLogin.text)));

                    }
                    print("Login "+_controllerLogin.text);
                    print("Senha "+_controllerSenha.text);
                  }),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext) => NovaConta()));
              },
              child: Text(
                "\nNovo Usuário",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  check_user(String text) async {
    var x = await FirebaseFirestore.instance.collection('usuario')
        .where('nome', isEqualTo: _controllerLogin.text).get();

    if (x.size > 0) {
      print("VERIFICOU USER EXISTE");
      setState(() {
        this.validp = true;
      });
      return true;
    } else {
      print("VERIFICOU USER NAO EXISTE");
      setState(() {
        this.validp = false;
      });
      return false;
    }
  }

  check_login(String text, String senha) async {
    var x = await FirebaseFirestore.instance.collection('usuario')
        .where('nome', isEqualTo: _controllerLogin.text)
        .where('senha', isEqualTo: _controllerSenha.text).get();

    if (x.size > 0) {
      print("VERIFICOU LOGIN EXISTE");
      setState(() {
        this.valids = true;
      });
      return true;
    } else {
      print("VERIFICOU LOGIN NAO EXISTE");
      setState(() {
        this.valids = false;
      });
      return false;
    }
  }
}
