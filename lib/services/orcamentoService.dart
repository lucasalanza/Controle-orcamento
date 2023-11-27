import 'dart:io';

import 'package:controleOrcamentos/db/banco.dart';
import 'package:sqflite/sqflite.dart';

import '../models/orcamentoModel.dart';
import 'contaService.dart';

class OrcamentoService {
  Future<int> gravarOrcamento(OrcamentoModel orcamento) async {
    // await Future.delayed(Duration(seconds: 5));
    Banco banco = Banco();
    var db = await banco.abrirBanco();

    int idGerado = await db.insert('tb_orcamentos', orcamento.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return idGerado;
  }

  Future<List<OrcamentoModel>> listarOrcamentos() async {
    Banco banco = Banco();
    var db = await banco.abrirBanco();

    List<OrcamentoModel> lista = [];

    var rows = await db.query('tb_orcamentos');

    rows.forEach((element) {
      lista.add(OrcamentoModel.fromTable(element));
    });

    for (OrcamentoModel orcamento in lista) {
      orcamento.contas = await ContaService()
          .buscaContasPorOrcamentoId(orcamento.orcamentoId!);
    }
    return lista;
  }

  Future<bool> deletarOrcamento(int id) async {
    Banco banco = Banco();

    var db = await banco.abrirBanco();
    int result = await db
        .delete('tb_contas', where: 'orcamento_id = ?', whereArgs: [id]);

    result = await db
        .delete('tb_orcamentos', where: 'orcamento_id = ?', whereArgs: [id]);

    return result > 0;
  }
}
