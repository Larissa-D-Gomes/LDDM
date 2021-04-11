import 'package:flutter/material.dart';


class SemSep extends StatefulWidget {
  @override
  _SemSepState createState() => _SemSepState();
}

class _SemSepState extends State<SemSep> {

  // VARIAVEIS
  final _valor = TextEditingController();
  final _quantidade = TextEditingController();
  var _infoText = "Informe os dados.";
  var _formKey = GlobalKey<FormState>();
  double _porcentagem = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Racha Conta"),
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
    _valor.text = "";
    _quantidade.text = "";
    _porcentagem = 0.0;
    setState(() {
      _infoText = "Informe os dados.";
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
              _editText("Valor (R\$)", _valor),
              _editText("Quantidade de pessoas", _quantidade),
              Text(
                "\nPorcentagem Garçom",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.grey, fontSize: 20.0),
              ),
              slider(),
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
        fontSize: 20,
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

  void _calculate(){
    setState(() {
      double quant = double.parse(_quantidade.text);
      double valor = double.parse(_valor.text);
      double porc = _porcentagem/100;
      double gc = (valor * porc);
      double total = valor + gc;
      double pp = total/quant ;
      String t = total.toStringAsFixed(2);
      String g = gc.toStringAsFixed(2);
      String p = pp.toStringAsFixed(2);
      _infoText = "Valor garçom:               R\$" + g
          + "\n\nValor total:                     R\$" + t
          + "\n\nValor individual:            R\$" + p;
    });
  }

  // // Widget text
  _textInfo() {
    return Text(
      _infoText,
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),

    );
  }

  Widget slider() {
    return Slider(
      value: _porcentagem,
      min: 0,
      max: 100,
      divisions: 10,
      label: _porcentagem.round().toString(),
      onChanged: (double value) {
        setState(() {
          _porcentagem = value;
        });
      },
    );
  }
}

