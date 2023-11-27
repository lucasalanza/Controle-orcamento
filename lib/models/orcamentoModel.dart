import 'package:controleOrcamentos/models/contaModel.dart';
import 'package:controleOrcamentos/services/contaService.dart';

class OrcamentoModel {
  int? orcamentoId;
  double orcamentoValor;
  int orcamentoMes;
  int orcamentoAno;
  List<ContaModel> contas = List.empty();

  OrcamentoModel(this.orcamentoId, this.orcamentoValor, this.orcamentoMes,
      this.orcamentoAno, this.contas);

  OrcamentoModel.fromTable(Map<String, dynamic> row)
      : orcamentoId = row['orcamento_id'],
        orcamentoValor = row['orcamento_valor'],
        orcamentoMes = row['orcamento_mes'],
        orcamentoAno = row['orcamento_ano'] {
    ContaService().buscaContasPorOrcamentoId(orcamentoId!).then((contasFuturo) {
      contas =
          contasFuturo; // Atribui a lista de contas ao campo 'contas' quando o futuro é resolvido
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'orcamento_id': orcamentoId == 0 ? null : orcamentoId,
      'orcamento_valor': orcamentoValor,
      'orcamento_mes': orcamentoMes,
      'orcamento_ano': orcamentoAno,
    };
  }
}
