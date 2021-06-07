import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPet extends StatefulWidget {
  @override
  DocumentSnapshot data;

  EditPet(this.data);

  _EditPet createState() => _EditPet();
}

class _EditPet extends State<EditPet> {
  TextEditingController _controllerEspecie = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();
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
    _controllerEspecie.text = widget.data['especie'];
    _controllerNasc.text = widget.data['aniversario'];
  }

  @override
  Widget build(BuildContext context) {
    db = FirebaseFirestore.instance;
    print(widget.data['img']);
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Pet",
            style: TextStyle(color: Colors.white, fontSize: 23)),
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
                  return "Digite o nome ";
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
                    "Editar Pet",
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
                        'especie': _controllerEspecie.text,
                        'nome': _controllerNome.text,
                        'aniversario': _controllerNasc.text,
                        'img': imageUrl,

                      });

                      setState(() {
                        ok = "Pet editado com sucesso!";
                      });
                    }
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\n\t\t\t\t\t\t" + ok,
              //textAlign: Texcenter,
              style: TextStyle(
                color: Colors.lightGreen,
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
            .child('${widget.data['dono']}/${widget.data['nome']}')
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

}