import 'package:flutter/material.dart';

import 'jogonum.dart';

class Num extends StatefulWidget {
  @override

  _Num createState() => _Num();
}

class _Num extends State<Num> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogos Educativos - Números"),
      ),
      body: _body(),
    );
  }

  _body(){
    return SingleChildScrollView(
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
                            _button(0),
                            _button(1),
                            _button(2),

                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _button(3),
                            _button(4),
                            _button(5),

                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _button(6),
                            _button(7),
                            _button(8),

                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _button(9),
                            _button(10),
                            _button(11),

                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _button(12),
                            _button(13),
                            _button(14),

                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _button(15),
                            _button(16),
                            _button(17),

                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _button(18),
                            _button(19),
                            _button(20),

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

  _button(int num) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 95,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.deepOrange,
        child:
        Text(
          num.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute( builder: (BuildContext) => NumJ(num)));

        },
      ),
    );
  }

}