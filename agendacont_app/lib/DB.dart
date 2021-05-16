import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:async';

class DB {
  static save(String n, String s) async{
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection("usuario").doc("login").set(
        {"nome": n, " senha": s});
  }
}