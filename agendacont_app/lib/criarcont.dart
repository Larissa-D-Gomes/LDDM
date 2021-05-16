import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class NovoCont extends StatefulWidget {
  @override
  String idUser;

  NovoCont(this.idUser);

  _NovoCont createState() => _NovoCont();
}

class _NovoCont extends State<NovoCont> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerCEP = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool valid = false;
  String ok = "";

  String erro = "";
  FirebaseFirestore db;

  @override
  Widget build(BuildContext context) {
    db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Contato"),
      ),
      body: Form(
        //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
        key: _formKey, //estado do formulário
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Nome:", hintText: "Digite o nomes"),
              controller: _controllerNome,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o texto";
                }
                //if(!this.valid)
                //return "Usuário já cadastrado.";

                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Email:", hintText: "Digite o email"),
              controller: _controllerEmail,
              keyboardType: TextInputType.emailAddress,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o email ";
                }

                if(!this.valid)
                  return "E-mail já cadastrado";

                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "CEP:", hintText: "Digite o CEP"),
              controller: _controllerCEP,
              keyboardType: TextInputType.number,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o CEP ";
                }

                return null;
              },
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Endereço:", hintText: "Digite o endereço"),
              controller: _controllerEndereco,
              keyboardType: TextInputType.text,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o endereço ";
                }

                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Telefone:", hintText: "Digite o telefone"),
              controller: _controllerTelefone,
              keyboardType: TextInputType.phone,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o telefone ";
                }

                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text(
                    "Criar contato",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    valid = ! await check_email(_controllerEmail.text);

                    bool formOk = _formKey.currentState.validate();

                    if (!formOk || !valid  ) {
                      print("entrou a");
                      setState(() {
                        ok = "";
                      });
                      return;
                    } else {
                      print("entrou");

                      await FirebaseFirestore.instance.collection('contato').add({
                        'email': _controllerEmail.text,
                        'nome': _controllerNome.text,
                        'CEP': _controllerCEP.text,
                        'endereco': _controllerEndereco.text,
                        'excluido': false,
                        'telefone': _controllerTelefone.text,
                        'fk': widget.idUser,

                      });

                      setState(() {
                        ok = "Contato cadastrado com sucesso!";
                      });
                    }
                    print("Nome " + _controllerNome.text);
                    print("Email " + _controllerEmail.text);
                  }),
            ),
            SizedBox(
              height: 10,
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

  check_email(String text) async {
    print("EntrouC");
    var x = await FirebaseFirestore.instance.collection('contato')
        .where('email', isEqualTo: _controllerEmail.text).get();

    print("a");
    print(x.docs);
    if(x.size == 0) {
      print(0);
      return false;
    }
    return true;
  }
}
