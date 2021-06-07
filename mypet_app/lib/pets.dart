
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'editpet.dart';
import 'lista.dart';
import 'novopet.dart';

final _formKey = GlobalKey<FormState>();

class Pets extends StatefulWidget {
  @override
  String idUser;

  Pets(this.idUser);

  _Pets createState() => _Pets();
}

class _Pets extends State<Pets> {
  TextEditingController _controllerPesquisa = TextEditingController();
  List<DocumentSnapshot> r = null;
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    var snap = FirebaseFirestore.instance
        .collection("pet")
        .where('excluido', isEqualTo: false)
        .where('dono', isEqualTo: widget.idUser)
        .snapshots();

    return Scaffold(
          appBar: AppBar(
            title: Text("MyPet  \u{1F43E}"),
          ),
          body:body(snap),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.lightGreen,
              elevation: 6,
              child: Icon(Icons.add),
              onPressed: () {
                print("Botão pressionado!");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => NovoPet(widget.idUser)));
              }),
        );
  }

  body(var snap) {
    return StreamBuilder(
      stream: snap,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.docs.length == 0) {
          return Center(child: Text('Nenhum Pet Cadastrado'));
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            var item = snapshot.data.docs[index];
            return Container(
                padding: EdgeInsets.only(top: 12, left: 16, right: 16),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        item['img'] == null || item['img'] == ''
                            ? Container(
                            margin: EdgeInsets.only(top: 0),
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ))
                            : Container(
                            margin: EdgeInsets.only(top: 0),
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                    Image.network(item['img']).image))),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext) =>
                                                Lista(widget.idUser, item['nome'])));
                                  },
                                  child: Text(
                                    item['nome'],
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        Spacer(),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Colors.lightGreen,
                                  child: Icon(
                                    Icons.edit,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext) =>
                                                EditPet(item)));
                                  },
                                ),
                              ),

                            ])
                      ]),
                  Divider(color: Colors.black),
                ]));
          },
        );
      },
    );
  }

  pesquisar() async {
    print(_controllerPesquisa.text);
    var aux = (await FirebaseFirestore.instance
        .collection("contato")
        .where('excluido', isEqualTo: false)
        .where("nome", isEqualTo: _controllerPesquisa.text)
        .where('fk', isEqualTo: widget.idUser)
        .get())
        .docs;

    setState(() {
      r = aux;

      this._loading = false;
    });
    print(r.length);
  }
}
