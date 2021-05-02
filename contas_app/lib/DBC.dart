import 'package:contas_app/DB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:async';
import 'conta.dart';


class DBC {

  static   _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "bancoC1.bd");
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE conta (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, valor REAL,"
              " dono VARCHAR, feita INTEGER, data VARCHAR) ";
          db.execute(sql);
        }
    );
    print("aberto: " + bd.isOpen.toString() );
    return bd;

  }

  static salvar_conta(String dono, double val, String nome, String date, bool feita) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> c = {
      "nome": nome,
      "valor": val,
      "dono": dono,
      "feita": feita,
      "data": date
    };
    int id = await bd.insert("conta", c);
    print("Salvo: $id " );
  }

  static recuperar_tudo(String dono) async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM conta WHERE dono='" + dono + "'";
    List c = await bd.rawQuery(sql);

    List<Conta> r = [];

    for(var v in c) {
      r.add(Conta(v['id'], v['dono'], v['valor'], v['nome'], v['data'], v['feita']));
      /*print(v['dono']);
      print(v['valor']);
      print(v['nome']);
      print(v['data']);
      print(v['feita']);*/
    }

    return r;
  }


  static excluirConta(int id) async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "conta",
        where: "id = " + id.toString(),  //caracter curinga
    );
    print("Itens excluidos: "+retorno.toString());
  }

  static printBD() async {
    print("=-=-= PRINT BD =-=-=");
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios ";
    List usuarios = await bd.rawQuery(sql);
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() +
          " nome: "+usu['nome']);
    }
    /*print(usuarios.length);
    if(usuarios.length == 0)
      this.existe =  false;
    this.existe =  true;*/
  }

  static update(int id, Conta c) async{
    Database bd = await _recuperarBancoDados();
    int i = 0;
    if(c.feita)
      i =1;
    Map<String, dynamic> dadosUsuario = {
      "id": id,
      "nome": c.nome,
      "valor": c.val,
      "dono": c.dono,
      "feita": i,
      "data": c.date
    };
    int retorno = await bd.update(
        "conta", dadosUsuario,
        where: "id = ?",  //caracter curinga
        whereArgs: [id]
    );
    print("Itens atualizados: "+ c.nome);
  }

  static Future close() async {
    Database bd = await _recuperarBancoDados();
    bd.close();
  }
}