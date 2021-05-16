import 'package:agendacont_app/criarcont.dart';
import 'package:agendacont_app/novaconta.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'DBC.dart';
import 'conta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final _formKey = GlobalKey<FormState>();

class Lista extends StatefulWidget {
  @override
  String idUser;

  Lista(this.idUser);

  _Lista createState() => _Lista();
}

class _Lista extends State<Lista> {
  TextEditingController _controllerConta = TextEditingController();
  TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerData = TextEditingController();
  List<Conta> r = new List();
  bool _loading = true;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    //_tabController =  TabController( length: myTabs.length);
    print("entrou");
    /*DBC.recuperar_tudo(widget.idUser).then((list) {
      setState(() {
        r = list;
        print(list);
        this._loading = false;
      });
    });*/
  }

  limpartext() {
    _controllerConta.text = "";
    _controllerValor.text = "";
    _controllerData.text = "";
  }

  reloadlist() async {
    /* DBC.recuperar_tudo(widget.idUser).then((list) {
      setState(() {
        r = list;
        print(list);
        this._loading = false;
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    var snap = FirebaseFirestore.instance
        .collection("contato")
        .where('excluido', isEqualTo: false)
        .where('fk', isEqualTo: widget.idUser)
        .snapshots();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Text(
                  "Contatos",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Pesquisar",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            title: Text("Contatos"),
          ),
          body: TabBarView(children: [
            body(snap),
            aux(),
          ]),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              elevation: 6,
              child: Icon(Icons.add),
              onPressed: () {
                print("Botão pressionado!");
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext) => NovoCont(widget.idUser)));
              }),
        ));
  }

  aux() {
    return Text("a");
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
          return Center(child: Text('Nenhum Contato'));
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
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child:
                                TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text(item['nome']),
                                            content: Container(
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Endereço: \n" +
                                                          item['endereco'] + "\n",
                                                      style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "CEP:  \n" + item['CEP'] + "\n",
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Telefone: \n" +
                                                        item['telefone'] + "\n",
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "E-mail: \n" + item['email'] + "\n",
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 15,
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Fechar",
                                                  ))


                                            ]);
                                      });
                                },
                                child: Text(
                                  item['nome'],
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline,
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
                                  color: Colors.deepOrange,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  color: Colors.deepOrange,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  onPressed: () async {
                                   item.reference.update({'excluido': true});
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

  update(int x, Conta c) async {
    // DBC.update(r[x].id, c);
  }
}
