import 'package:contas_app/novaconta.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DBC.dart';
import 'conta.dart';

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

  @override
  void initState() {
    super.initState();
    print("entrou");
    DBC.recuperar_tudo(widget.idUser).then((list) {
      setState(() {
        r = list;
        print(list);
        this._loading = false;
      });
    });
  }

  limpartext(){
    _controllerConta.text = "";
    _controllerValor.text = "";
    _controllerData.text  = "";
  }

  reloadlist() async {

    DBC.recuperar_tudo(widget.idUser).then((list) {
      setState(() {
        r = list;
        print(list);
        this._loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contas"),
      ),
      body: body(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          elevation: 6,
          child: Icon(Icons.add),
          onPressed: () {
            print("Botão pressionado!");
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Adicionar conta: ",
                        style: TextStyle(fontSize: 15)),
                    content: Container(height: 200, child: form()),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text("Cancelar")),
                      TextButton(
                          onPressed: () async {
                            bool formOk = _formKey.currentState.validate();
                            if (formOk) {
                              await DBC.salvar_conta(
                                  widget.idUser,
                                  double.parse(_controllerValor.text),
                                  _controllerConta.text,
                                  _controllerData.text,
                                  false);
                              print(formOk);
                              Navigator.pop(context);
                              reloadlist();
                              limpartext();
                            }
                          },
                          child: Text("Salvar")),
                    ],
                  );
                });
          }),
    );
  }

  form() {
    return Form(
      //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
      key: _formKey, //estado do formulário
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          TextFormField(
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: "Conta:", hintText: "Digite o nome da conta."),
            controller: _controllerConta,
            validator: (String text) {
              if (text.isEmpty) {
                return "Digite o nome";
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
                labelText: "Valor:", hintText: "Digite o valor (R\$)"),
            controller: _controllerValor,
            keyboardType: TextInputType.number,
            validator: (String text) {
              if (text.length == 0) {
                return "Valor não preenchido";
              }
              if (double.parse(text) < 0.0) {
                return "Isso é impossível... Digite um valor positivo";
              }

              return null;
            },
          ),
          TextFormField(
            controller: _controllerData,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: "Data",
            ),
            validator: (value) {
              if (value.isEmpty) return "Digite a data";
              return null;
            },
          ),
        ],
      ),
    );
  }

  body() {
    if (r.isEmpty)
      return Center(
        child: _loading ? CircularProgressIndicator() : Text("Sem contas"),
      );
    else
      return ListView.builder(
        itemCount: r.length,
        itemBuilder: (context, index) {
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
                        Text(
                          r[index].nome,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Valor: " + r[index].val.toString(),
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Data:  " + r[index].date,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                          ),
                        ),
                      ]),
                      Spacer(),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Checkbox(
                            value: r[index].feita,
                            onChanged: (bool newValue) async {
                              await update(index, r[index]);
                              setState(() {
                                r[index].feita = newValue;
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              color: Colors.deepOrange,
                              child:
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20.0,

                              ),
                              onPressed: () {
                                _controllerConta.text = r[index].nome;
                                _controllerValor.text = r[index].val.toString();
                                _controllerData.text  = r[index].date;
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title: Text("EDITAR"),
                                          content: Container(height: 200, child: form()),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancelar")),
                                            TextButton(
                                                onPressed: () async {
                                                  bool formOk = _formKey.currentState.validate();
                                                  if (formOk) {
                                                    Conta n;
                                                    if(r[index].feita)
                                                      n = new Conta(r[index].id, r[index].dono, double.parse(_controllerValor.text), _controllerConta.text, _controllerData.text, 1);
                                                    else
                                                      n = new Conta(r[index].id, r[index].dono, double.parse(_controllerValor.text), _controllerConta.text, _controllerData.text, 0);


                                                    print(r[index].id);
                                                    await update(index, n);
                                                    print(formOk);
                                                    Navigator.pop(context);
                                                    reloadlist();
                                                    limpartext();
                                                  }
                                                },
                                                child: Text("Salvar")),
                                          ]
                                      );
                                    }
                                );

                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              color: Colors.deepOrange,
                              child:
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20.0,

                              ),
                              onPressed: () async{
                                await DBC.excluirConta(r[index].id);
                                reloadlist();
                              },
                            ),
                          ),

                    ])
                  ]),
                Divider(color: Colors.black),
              ]));
        },
      );
  }


  update(int x, Conta c)async{
    DBC.update(r[x].id, c);
  }

}
