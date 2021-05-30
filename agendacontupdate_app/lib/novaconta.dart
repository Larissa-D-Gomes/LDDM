import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class NovaConta extends StatefulWidget {
  @override
  _NovaConta createState() => _NovaConta();
}

class _NovaConta extends State<NovaConta> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool valid = false;
  String ok = "";

  String erro = "";
  var snapshots = FirebaseFirestore.instance
      .collection('usuario')
      .snapshots();


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
                    valid = !p;
                    print(p);
                    bool formOk = _formKey.currentState.validate();

                    if (!formOk || p  ) {

                      print("entrou a");
                      setState(() {
                        ok = "";
                      });
                      return;
                    } else {
                      print("entrou else");

                      await FirebaseFirestore.instance.collection('usuario').add({
                        'nome': _controllerLogin.text,
                        'senha': _controllerSenha.text,

                      });


                      setState(() {
                        ok = "Conta cadastrada com sucesso!";
                      });
                    }
                    print("Login " + _controllerLogin.text);
                    print("Senha " + _controllerSenha.text);
                  }),
            ),
            Text(
              "\n\t\t\t " + ok,
              //textAlign: Texcenter,
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  check_user(String text) async {
    print("EntrouC");
    var x = await FirebaseFirestore.instance.collection('usuario')
        .where('nome', isEqualTo: _controllerLogin.text).get();

    print("a");
    print(x.docs);
    if(x.size == 0) {
      print(0);
      return false;
    }
    return true;
  }
}
