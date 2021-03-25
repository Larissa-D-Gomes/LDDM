import 'package:flutter/material.dart';


class Sep extends StatefulWidget {
  @override
  _SepState createState() => _SepState();
}

class _SepState extends State<Sep> {

  // VARIAVEIS
  final _valor = TextEditingController();
  final _valorb = TextEditingController();
  final _quantidade = TextEditingController();
  final _quantidadeBA = TextEditingController();
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
              _editText("Valor sem bebidas(R\$)", _valor),
              _editText("Valor bebidas(R\$)", _valorb),
              _editText("Pessoas que não beberam", _quantidade),
              _editText("Pessoas que beberam", _quantidadeBA),
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
        fontSize: 15,
        color: Colors.blueGrey,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize:20,
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
      height: 35,
      child: RaisedButton(
        color: Colors.blueGrey,
        child:
        Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
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
      //parse
      double quant = double.parse(_quantidade.text);
      double quantb = double.parse(_quantidadeBA.text);
      double valor = double.parse(_valor.text);
      double valorb = double.parse(_valorb.text);

      //Valores para todos bebeu
      double porc = _porcentagem/100;
      double gc = (valor * porc);
      double total = valor + gc;
      double pp = total/(quant + quantb) ;

      //Valores para quem bebeu bebeu
      double gcb = (valorb * porc);
      double totalb =  valorb + gcb;
      double ppb = (totalb/(quantb) )+ pp;

      //toString
      String t = (total + totalb).toStringAsFixed(2);
      String g = (gc + gcb).toStringAsFixed(2);
      String p = pp.toStringAsFixed(2);
      String pb = ppb.toStringAsFixed(2);
      _infoText = "Valor garçom:                   R\$" + g
          + "\n\nValor total:                         R\$" + t
          + "\n\nValor (sem bedidas):        R\$" + p
          + "\n\nValor (com bedidas):        R\$" + pb;
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

