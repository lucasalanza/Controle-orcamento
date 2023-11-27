import 'dart:ffi';
import 'dart:typed_data';

class ContaModel {
  int? contaId;
  String? contaDescricao;
  double contaValor; // Alterei Float para double
  bool contaPago;
  Uint8List? contaRecibo;
  int orcamentoId;

  ContaModel(this.contaId, this.contaDescricao, this.contaPago,
      this.contaRecibo, this.contaValor, this.orcamentoId);

  ContaModel.fromTable(Map<String, dynamic> row)
      : contaId = row['conta_id'],
        contaDescricao = row['conta_descricao'],
        contaValor = row['conta_valor'],
        contaPago = row['conta_pago'] == '1' ? true : false,
        contaRecibo = row['conta_recibo'],
        orcamentoId = row['orcamento_id'];

  Map<String, dynamic> toMap() {
    return {
      'conta_id': contaId == 0 ? null : contaId,
      'conta_descricao': contaDescricao,
      'conta_valor': contaValor,
      'conta_pago': contaPago ? '1' : '0',
      'conta_recibo': contaRecibo,
      'orcamento_id': orcamentoId,
    };
  }
}
