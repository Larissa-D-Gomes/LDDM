/* Nome: Larissa Domingues Gomes
 * Matricula: 650525
 * Disciplina LDDM - PUC-MG - CC - MANHA
 * Professora: Ivre Marjorie Ribeiro Machado
 * Conversor de temperatura APP v1.0
 */
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // VARIAVEIS
  final _temperatura = TextEditingController();
  final _tipo = TextEditingController();
  var _infoText = "Digite a temperatura.";
  bool _f = false;
  bool _k = false;
  bool _re = false;
  bool _ra = false;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de Temperatura"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
              onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields(){
    _temperatura.text = "";
    _tipo.text = "";
    setState(() {
      _f = false;
      _k = false;
      _re = false;
      _ra = false;
      _infoText = "Digite a temperatura.";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _editText("Temperatura °C", _temperatura),

              //Checkboxes
              SwitchListTile(
                title: const Text('Fahrenheit',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),),
                value: _f,
                onChanged: (bool value) {
                setState(() {
                  _f = value;
                });
              },

              ),
              SwitchListTile(
                title: const Text('Kelvin',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),),
                value: _k,
                onChanged: (bool value) {
                  setState(() {
                    _k = value;
                  });
                },

              ),
              SwitchListTile(
                title: const Text('Reaumur',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),),
                value: _re,
                onChanged: (bool value) {
                  setState(() {
                    _re = value;
                  });
                },

              ),
              SwitchListTile(
                title: const Text('Rankine',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),),
                value: _ra,
                onChanged: (bool value) {
                  setState(() {
                    _ra = value;
                  });
                },

              ),


              _buttonCalcular(),
              _textInfo(),
            ],
          ),

        ));
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
        color: Colors.blueGrey,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          color: Colors.grey,
        ),
      ),
    );
  }




  // PROCEDIMENTO PARA VALIDAR OS CAMPOS
  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "Digite $field";
    }else{
      if (!_f && !_k && !_ra && !_re) {
        return "Escolha uma medida.";
      }
    }
    return null;
  }

  // Widget button
  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blueGrey,
        child:
        Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()){
            _calculate();
          }
        },
      ),
    );
  }

  // PROCEDIMENTO PARA CALCULAR O IMC
  void _calculate(){
    setState(() {

      _infoText = "";
      double cels = double.parse(_temperatura.text);
      print(cels);
      if(_f)
        _infoText += ((cels * 9.0 / 5.0) + 32).toStringAsFixed(2) + " °F\n";

      if (_k)
        _infoText += (cels + 273.15).toStringAsFixed(2) + " K\n";

      if (_re)
        _infoText += (cels * (4/5)).toStringAsFixed(2) + " °Ré\n";

      if (_ra)
        _infoText += ((cels * (9.0/5.0) )+ 491.67).toStringAsFixed(2) + "°Ra";

    });
  }

  // // Widget text
  _textInfo() {
    return Text(
      _infoText,
      textAlign: TextAlign.center,
      
      style: TextStyle(color: Colors.blueGrey, fontSize: 23.0),
    );
  }


}
