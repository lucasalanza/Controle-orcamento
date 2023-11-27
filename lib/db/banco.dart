import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Banco {
  Future<Database> abrirBanco() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), "orcamento.db"),
      onCreate: (db, version) async {
        String script =
            await rootBundle.loadString("lib/db/initScript.sql", cache: false);
        List<String> comandos = script.split(";");
        comandos.forEach((comando) {
          if (comando.isNotEmpty) {
            db.execute(comando.trim());
          }
        });
      },
      version: 1,
    );

    return database;
  }
}
