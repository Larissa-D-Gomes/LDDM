import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:async';

class DB {
  static bool consultando = false;
  static   _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco3.bd");
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, senha VARCHAR) ";
          db.execute(sql);
        }
    );
    print("aberto: " + bd.isOpen.toString() );
    return bd;

  }


  static verificarUserBD(String text) async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios WHERE nome='" + text + "'";
    List usuarios = await bd.rawQuery(sql);

    //print(usuarios);
    if(usuarios.length == 0) {
      return false;
    }
    return true;

  }

  static verificar_login(String text,  String senha) async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios WHERE nome='" + text + "'";
    List usuarios = await bd.rawQuery(sql);

    //print(usuarios);
    if(usuarios.length > 0 && usuarios[0]['nome'] == text && usuarios[0]['senha'] == senha) {
      return true;
    }
    return false;

  }

  static salvar_conta(String login, String senha) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" : login,
      "senha" : senha
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id " );
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

  static Future close() async {
    Database bd = await _recuperarBancoDados();
    bd.close();
  }
}