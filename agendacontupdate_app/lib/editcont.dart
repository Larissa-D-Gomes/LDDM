import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditCont extends StatefulWidget {
  @override
  DocumentSnapshot data;

  EditCont(this.data);

  _EditCont createState() => _EditCont();
}

class _EditCont extends State<EditCont> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerLog = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerNumero = TextEditingController();
  TextEditingController _controllerCidade = TextEditingController();
  TextEditingController _controllerUf = TextEditingController();
  TextEditingController _controllerCEP = TextEditingController();
  TextEditingController _controllerNasc = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool valid = false;
  String ok = "";

  String erro = "";
  FirebaseFirestore db;
  final picker = ImagePicker();
  var storage = FirebaseStorage.instance;
  String imageUrl;
  File _image;

  @override
  void initState() {
    super.initState();
    _controllerNome.text = widget.data['nome'];
    _controllerTelefone.text = widget.data['telefone'];
    _controllerLog.text = widget.data['logradouro'];
    _controllerBairro.text = widget.data['bairro'];
    _controllerCidade.text = widget.data['localidade'];
    _controllerUf.text = widget.data['UF'];
    _controllerNumero.text = widget.data['numero'];
    _controllerCEP.text = widget.data['CEP'];
    _controllerNasc.text = widget.data['data'];
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
            _image == null
                ? Container(
                margin: EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(top: 40.0, left: 40),
                width: 90.0,
                height: 90.0,
                child: FloatingActionButton(
                  onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ))
                : Container(
                margin: EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(top: 40.0, left: 40),
                width: 90.0,
                height: 90.0,
                child: FloatingActionButton(
                  onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: Image.file(_image).image))),
            TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Nome:", hintText: "Digite o nome"),
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

            TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration:
              InputDecoration(labelText: "CEP:", hintText: "Digite o CEP"),
              controller: _controllerCEP,
              keyboardType: TextInputType.number,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o CEP ";
                }

                return null;
              },
              onChanged: (text) {
                get_cep();
              },
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Logradouro:", hintText: "Digite o endereço"),
              controller: _controllerLog,
              keyboardType: TextInputType.text,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o endereço ";
                }

                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        labelText: "Bairro", hintText: "Digite o bairro"),
                    controller: _controllerBairro,
                    validator: (String text) {
                      if (text.isEmpty) {
                        return "Digite o bairro";
                      }

                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 60),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "Número", hintText: "Digite o número"),
                      controller: _controllerNumero,
                      keyboardType: TextInputType.number,
                      validator: (String text) {
                        if (text.isEmpty) {
                          return "Digite o número";
                        }

                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        labelText: "Cidade", hintText: "Digite a cidade"),
                    controller: _controllerCidade,
                    validator: (String text) {
                      if (text.isEmpty) {
                        return "Digite a cidade";
                      }

                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 60),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "UF", hintText: "Digite a UF"),
                      controller: _controllerUf,
                      validator: (String text) {
                        if (text.isEmpty) {
                          return "Digite a UF";
                        }

                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
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
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 25),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: "Data de Nascimento", hintText: "Digite a data de nascimento"),
                      controller: _controllerNasc,
                      keyboardType: TextInputType.datetime,
                      validator: (String text) {
                        if (text.isEmpty) {
                          return "Digite a data de nascimento";
                        }

                        return null;
                      },
                    ),
                  ),
                ),
              ],
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
                      await uploadFile(_image);
                      await widget.data.reference.update({
                        'nome': _controllerNome.text,
                        'CEP': _controllerCEP.text,
                        'logradouro':_controllerLog.text,
                        'bairro': _controllerBairro.text,
                        'localidade': _controllerCidade.text,
                        'UF': _controllerUf.text,
                        'numero': _controllerNumero.text,
                        'excluido': false,
                        'telefone': _controllerTelefone.text,
                        'data': _controllerNasc.text,
                        'img': imageUrl,

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


  void uploadFile(File _image) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;


    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){

      if (_image != null){
        //Upload to Firebase
        var snapshot = await _storage.ref()
            .child('${widget.data['fk']}/${widget.data['email']}')
            .putFile(_image);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }

    } else {
      print('Grant Permissions and try again');
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  get_cep() async {
    String url = 'https://viacep.com.br/ws/${_controllerCEP.text.replaceAll('-','')}/json/';
    http.Response r = await http.get(Uri.parse(url));

    if(r.body[0] != '<') {
      Map<String, dynamic> resp = jsonDecode(r.body);
      setState(() {
        _controllerLog.text = resp['logradouro'];
        _controllerBairro.text = resp['bairro'];
        _controllerCidade.text = resp['localidade'];
        _controllerUf.text = resp['uf'];
      });
    }

  }
}