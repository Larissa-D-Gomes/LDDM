import 'package:flutter/material.dart';
import 'num.dart';
import 'letras.dart';
import 'sobre.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Jogos Educativos"),
        ),
      body: _body(),
    );
  }

  _body(){
    return  Center(
        child:
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(30),
                child:
                  Row(

                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        Text(
                          "Aprender... ",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 30,
                          )
                        )
                     ],
                  ),
              ),
              _buttonNum(),
              _buttonLet(),
              TextButton(
                  onPressed: () {
                    print('apertou');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext) => Sobre()));
                  },
                  child: Text(
                      "Sobre o App",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.deepOrange,
                        fontSize: 20,
                      )
                  )
              )
              ]
        )
    );
  }

  _buttonNum() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 95,
      width: 305,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.deepOrange,
        child:
        Text(
          "1 2 3",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute( builder: (BuildContext) => Num()));

        },
      ),
    );
  }

  _buttonLet() {
    return Container(
      margin: EdgeInsets.only(top: 0.0, bottom: 20),
      height: 95,
      width: 305,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.deepOrange,
        child:
        Text(
          "A B C",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute( builder: (BuildContext) => Letras()));
        },
      ),
    );
  }
}