import 'package:flutter/material.dart';


class Sobre extends StatefulWidget {
  @override

  _Sobre createState() => _Sobre();
}

class _Sobre extends State<Sobre> {
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogos Educativos - Sobre o APP"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      margin: EdgeInsets.all(20),
        child:
        Text(
            "O aplicativo tem como objetivo auxiliar pais durante a alfabetização de seus filhos com jogos educativos."
                "\n\nDurante o uso o ideal é que a criança esteja acompanhada de algum adulto.",

            style: TextStyle(
              fontSize: 16,

            )
    )
    );
  }
}
