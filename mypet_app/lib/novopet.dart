import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class NovoPet extends StatefulWidget {
  @override
  String idUser;

  NovoPet(this.idUser);

  _NovoPet createState() => _NovoPet();
}

class _NovoPet extends State<NovoPet> {
  TextEditingController _controllerEspecie = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerNasc = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool valid = false;
  String ok = "";

  String erro = "";
  FirebaseFirestore db;
  File _image;
  final picker = ImagePicker();
  var storage = FirebaseStorage.instance;
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Pet",
            style: TextStyle(color: Colors.white, fontSize: 23)),
      ),
      body: Form(
        //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
        key: _formKey, //estado do formulário
        child: ListView(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                  return "Digite o nome ";
                }

                if (!this.valid) return "Pet já cadastrado";

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
                        labelText: "Espécie:", hintText: "Digite a Espécie"),
                    controller: _controllerEspecie,
                    validator: (String text) {
                      if (text.isEmpty) {
                        return "Digite a espécie ";
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
                          labelText: "Data de Nascimento",
                          hintText: "Digite a data de nascimento"),
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
                    "Cadastrar pet",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    valid = !await check_nome(_controllerNome.text);

                    bool formOk = _formKey.currentState.validate();

                    if (!formOk || !valid) {
                      setState(() {
                        ok = "";
                      });
                      return;
                    } else {
                      print("entrou");
                      await uploadFile(_image);
                      await FirebaseFirestore.instance
                          .collection('pet')
                          .add({
                        'especie': _controllerEspecie.text,
                        'nome': _controllerNome.text,
                        'excluido': false,
                        'dono': widget.idUser,
                        'aniversario': _controllerNasc.text,
                        'img': imageUrl,
                      });

                      setState(() {
                        ok = "Pet cadastrado com sucesso!";
                      });
                    }
                    print("Nome " + _controllerNome.text);
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\n\t\t\t " + ok,
              //textAlign: Texcenter,
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
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

  void uploadFile(File _image) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      if (_image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('${widget.idUser}/${_controllerNome.text}')
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

  check_nome(String text) async {
    print("EntrouC");
    var x = await FirebaseFirestore.instance
        .collection('pet')
        .where('nome', isEqualTo: _controllerNome.text)
        .get();

    print("a");
    print(x.docs);
    if (x.size == 0) {
      print(0);
      return false;
    }
    return true;
  }

}
