import 'package:flutter/material.dart';

import 'num.dart';

class NumJ extends StatefulWidget {
  @override
  int n;

  NumJ(this.n);

  _NumJ createState() => _NumJ();
}

class _NumJ extends State<NumJ> {
  @override
  int x = 1;
  String result = "\u{1F436}";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogos Educativos - Números"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        height: 80,
        padding: EdgeInsets.all(20),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            "Mostre " + widget.n.toString() + " cachorro(s) na Tela:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
            ),
          )
        ]),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buttonMenos(), _buttonSoma()],
      ),
      _buttonEnviar(),
      Container(
          margin: EdgeInsets.only(left: 35, right: 35, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                x.toString(),
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 50,
                ),
              ),
              Text(
                result,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                ),
              ),
            ],
          )),

    ]));
  }

  _buttonSoma() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 10.0),
      height: 60,
      width: 100,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.deepOrange,
        child: Text(
          "+",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        onPressed: () {
          if (x + 1 <= 20) {
            setState(() {
              x++;
            });
            setResult();
            print(x);
          }
        },
      ),
    );
  }

  _buttonMenos() {
    return Container(
      margin: EdgeInsets.only(right: 10.0, bottom: 20),
      height: 60,
      width: 100,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.deepOrange,
        child: Text(
          "-",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        onPressed: () {
          if (x - 1 >= 0) {
            setState(() {
              x--;
            });
            setResult();
            print(x);
          }
        },
      ),
    );
  }

  _buttonEnviar() {
    return Container(
      margin: EdgeInsets.only(right: 0.0, bottom: 0),
      height: 50,
      width: 230,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.green,
        child: Text(
          "Enviar Resposta",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        onPressed: () {
          if (x == widget.n && widget.n != 20)
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("PARABÉNS! \u{1F603}"),
                      content: Text("Você acertou!"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Voltar")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                widget.n++;
                                x = 1;
                                result = "\u{1F436}";
                              });
                            },
                            child: Text("Próximo número"))
                      ]);
                });
          else if (x != widget.n)
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("QUASE! \u{1F609}"),
                      content: Text("Você errou..."),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Voltar")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                widget.n;
                                x = 1;
                                result = "\u{1F436}";
                              });
                            },
                            child: Text("Tentar novamente."))
                      ]);
                });
          else
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("PARABÉNS! \u{1F603}"),
                      content: Text("Você acertou!"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Voltar")),
                      ]);
                });
        },
      ),
    );
  }

  setResult() {
    setState(() {
      if (x > 0)
        result = "\u{1F436} " + " \u{1F436} " * (x - 1);
      else
        result = "";
    });
  }
}
