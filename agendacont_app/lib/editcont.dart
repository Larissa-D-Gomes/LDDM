import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class EditCont extends StatefulWidget {
  @override
  DocumentSnapshot data;

  EditCont(this.data);

  _EditCont createState() => _EditCont();
}

class _EditCont extends State<EditCont> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerCEP = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool valid = false;
  String ok = "";

  String erro = "";
  FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    _controllerNome.text = widget.data['nome'];
    _controllerTelefone.text = widget.data['telefone'];
    _controllerEndereco.text = widget.data['endereco'];
    _controllerCEP.text = widget.data['CEP'];
  }

  @override
  Widget build(BuildContext context) {
    db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Contato"),
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
                    "Editar contato",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    bool formOk = _formKey.currentState.validate();

                    if (!formOk) {
                      print("entrou a");
                      setState(() {
                        ok = "";
                      });
                      return;
                    } else {
                      print("entrou");

                      await widget.data.reference.update({
                        'nome': _controllerNome.text,
                        'CEP': _controllerCEP.text,
                        'endereco': _controllerEndereco.text,
                        'excluido': false,
                        'telefone': _controllerTelefone.text,

                      });

                      setState(() {
                        ok = "Contato editado com sucesso!";
                      });
                    }
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
}