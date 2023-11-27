import 'package:controleOrcamentos/db/banco.dart';
import 'package:controleOrcamentos/models/contaModel.dart';
import 'package:sqflite/sqflite.dart';

class ContaService {
  Future<void> salvarConta(ContaModel conta) async {
    Banco banco = Banco();
    var db = await banco.abrirBanco();
if (conta.contaId==0)
{conta.contaId= null;}
    await db.insert(
      'tb_contas',
      conta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> deletaConta(int id) async {
    Banco banco = Banco();
    var db = await banco.abrirBanco();

    return await db.delete('tb_contas', where: "conta_id=?", whereArgs: [id]) >
        0;
  }

  Future<List<ContaModel>> listarContas() async {
    Banco banco = Banco();
    var db = await banco.abrirBanco();
    List<ContaModel> lista = [];

    var rows = await db.query('tb_contas');

    rows.forEach((element) {
      lista.add(ContaModel.fromTable(element));
    });

    return lista;
  }

  Future<List<ContaModel>> buscaContasPorOrcamentoId(int orcamentoId) async {
    Banco banco = Banco();
    var db = await banco.abrirBanco();
    List<ContaModel> lista = [];

    var rows = await db.query('tb_contas',
        where: 'orcamento_id = ?', whereArgs: [orcamentoId]);

    rows.forEach((element) {
      lista.add(ContaModel.fromTable(element));
    });

    return lista;
  }
}
