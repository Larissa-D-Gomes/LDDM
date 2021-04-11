import 'package:flutter/material.dart';

import 'jogoletra.dart';

class Letras extends StatefulWidget {
  @override
  _Letras createState() => _Letras();
}

class _Letras extends State<Letras> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogos Educativos - Letras"),
      ),
      body: _body(),
    );
  }

  _body(){
    return  SingleChildScrollView(
        child:
        Center(
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    child:
                    Column(
                        children: [
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('A'),
                              _button('B'),
                              _button('C'),

                            ],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('D'),
                              _button('E'),
                              _button('F'),

                            ],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('G'),
                              _button('H'),
                              _button('I'),

                            ],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('J'),
                              _button('K'),
                              _button('L'),

                            ],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('M'),
                              _button('N'),
                              _button('O'),

                            ],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('P'),
                              _button('Q'),
                              _button('R'),

                            ],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('S'),
                              _button('T'),
                              _button('U'),

                            ],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('V'),
                              _button('W'),
                              _button('X'),

                            ],
                          ),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _button('Y'),
                              _button('Z'),

                            ],
                          ),
                        ]
                    ),
                  ),
                ]
            )
        )
    );
  }

  _button(String letra) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 95,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.deepOrange,
        child:
        Text(
          letra,
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute( builder: (BuildContext) => LetraJ(letra)));

        },
      ),
    );
  }

}