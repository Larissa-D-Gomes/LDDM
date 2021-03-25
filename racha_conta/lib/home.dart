import 'package:flutter/material.dart';
import 'package:racha_conta/semsep.dart';
import 'package:racha_conta/sep.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Racha Conta"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 150.0),
        child:
        Center(
            child:
            Column(
              children: [
                  Row(
                  children: [
                    Text(
                      "\t\t\t\t Como deseja rachar a conta?",

                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 22,
                          fontWeight: FontWeight.bold,

                      ),
                    ),
                  ],
                ),
                _buttonSemSep(),
                _buttonSep()
              ],
            )
        ));
  }


  _buttonSemSep() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      width: 305,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.blueGrey,
        child:
        Text(
          "Igual Para Todos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {          Navigator.push(context, MaterialPageRoute( builder: (BuildContext) => SemSep()));

        },
      ),
    );
  }

  _buttonSep() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      width: 305,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.blueGrey,
        child:
        Text(
          "Separar Bebidas Alcoólicas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute( builder: (BuildContext) => Sep()));
        },
      ),
    );
  }
}


