import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class LetraJ extends StatefulWidget {
  @override
  String l;

  LetraJ(this.l);

  _LetraJ createState() => _LetraJ();
}

class _LetraJ extends State<LetraJ> {
  @override
  var letras = ['\u{1F333}', '\u{26BD}', '\u{1F436}', '\u{1F996}', '\u{1F418}', '\u{1F41C}',
    '\u{1F414}', '\u{1F99B}', '\u{26EA}','\u{1F40A}', '\u{1F95D}', '\u{1F981}', '\u{1F412}',
    '\u{2601}', '\u{1F411}', '\u{1F416}', '\u{1F9C0}', '\u{1F401}', '\u{1F438}', '\u{1F4FA}',
    '\u{1F347}', '\u{1F404}', '\u{1F9C7}', '\u{2615}', '\u{1F9D8}', '\u{1f993}'];

  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogos Educativos - Letras"),
      ),
      body: _body(),
    );
  }

  _body() {
    List <String> s = new List();
    s.add(letras[widget.l.codeUnitAt(0) - 65]);
    Random random = new Random(DateTime.now().millisecondsSinceEpoch);

    for(int i = 1; i < 4; i++){
      int rand = random.nextInt(letras.length);

      if(!s.contains(letras[rand]))
        s.add(letras[rand]);
      else
        i--;
    }
    s.shuffle();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.only(top: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  widget.l + " de...",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                  ),
                ),

              ]),
            ),
            Container(

              padding: EdgeInsets.only(left: 30),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _buttonImg(s[0]),
                _buttonImg(s[1]),
              ]),
            ),
            Container(

              padding: EdgeInsets.only(left: 30),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _buttonImg(s[2]),
                _buttonImg(s[3]),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  _buttonImg(String img) {
    return Container(
      margin: EdgeInsets.only(bottom: 30, right: 30),
      height: 130,
      width: 130,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.deepOrange,
        child:
        Text(
         img,
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
        onPressed: () {
          print("apertou");

          if(img == letras[widget.l.codeUnitAt(0) - 65]
              && letras[widget.l.codeUnitAt(0) - 65] != '\u{1f993}') {
            print("igual");
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("PARABÉNS! \u{1F603}"),
                    content: Text("Você acertou!"),
                     actions: <Widget>[
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Voltar")
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                              setState(() {
                                widget.l = String.fromCharCode(widget.l.codeUnitAt(0)+1);

                              });

                            },
                            child: Text("Próxima letra")
                        )
                      ]
                  );
                }
            );
          }else{
            if(img != letras[widget.l.codeUnitAt(0) - 65] ) {
              print("Diferente");
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
                              child: Text("Voltar")
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Tentar novamente.")
                          )
                        ]
                    );
                  }

              );
            } else{
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text("PARABÉNS! \u{1F603}"),
                        content: Text("Você acertou!"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("Voltar")
                          ),

                        ]
                    );
                  }
              );
            }
          }
        },
      ),
    );
  }
}
