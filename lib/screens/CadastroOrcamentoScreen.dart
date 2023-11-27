import 'package:controleOrcamentos/models/contaModel.dart';
import 'package:controleOrcamentos/models/orcamentoModel.dart';
import 'package:controleOrcamentos/screens/cadastroContaScreen.dart';
import 'package:controleOrcamentos/services/contaService.dart';
import 'package:flutter/material.dart';

import '../services/orcamentoService.dart';

class CadastroOrcamentoScreen extends StatefulWidget {
  final OrcamentoModel orcamento;

  const CadastroOrcamentoScreen({Key? key, required this.orcamento})
      : super(key: key);

  @override
  _CadastroOrcamentoScreenState createState() =>
      _CadastroOrcamentoScreenState();
}

class _CadastroOrcamentoScreenState extends State<CadastroOrcamentoScreen> {
  late TextEditingController _valorController;
  List<int> years = [2023, 2024];
  List<int> months = List.generate(12, (index) => index + 1);

  late int _anoSelecionado = 2023; // Valor inicial para o ano
  late int _mesSelecionado = 1; // Valor inicial para o mês
  List<ContaModel> contas = [];
  double valorGasto = 0.0;
  @override
  void initState() {
    super.initState();
    // Inicializar os controladores de texto com os valores do orcamento
    _valorController =
        TextEditingController(text: widget.orcamento.orcamentoValor.toString());
    _anoSelecionado = widget.orcamento.orcamentoAno;
    _mesSelecionado = widget.orcamento.orcamentoMes;
    contas = widget.orcamento.contas;
    if (widget.orcamento.orcamentoId != null) {}
  }

  Widget dialogDocument(ContaModel doc) {
    return AlertDialog(
      title: Text(doc.contaDescricao!),
      content: Container(
        child: Image.memory(doc.contaRecibo!),
      ),
    );
  }

  Future<void> _carregarContasDoOrcamento() async {
    try {
      List<ContaModel> listaContas = await ContaService()
          .buscaContasPorOrcamentoId(widget.orcamento.orcamentoId!);
      setState(() {
        contas = listaContas;
        valorGasto = contas.fold(
            0, (previous, current) => previous + current.contaValor);
      });
    } catch (e) {
      // Exibir mensagem de erro, se necessário
    }
  }

  @override
  void dispose() {
    // Dispose os controladores de texto quando não forem mais necessários
    _valorController.dispose();
    super.dispose();
  }

  void adicionaConta() {
    // Verifica se o orçamento já foi gravado
    if (widget.orcamento.orcamentoId! > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroContaScreen(
            conta: ContaModel(
                0, '', false, null, 0, widget.orcamento.orcamentoId!),
          ),
        ),
      ).then((value) => _carregarContasDoOrcamento());
    } else {
      // Orçamento não gravado, exibe um diálogo ou mensagem informando ao usuário
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Orçamento não gravado'),
          content:
              const Text('Grave o orçamento antes de adicionar uma conta.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void limparCampos() {
    setState(() {
      // Define os valores dos controllers como vazios
      // _valorController.clear();
      // _mesController.clear();
      // _anoController.clear();
    });
  }

  void removeConta(int contaId) async {
    // Adicione aqui a lógica para excluir a conta no seu banco de dados
    await ContaService().deletaConta(contaId);
    _carregarContasDoOrcamento();
  }

  void salvaOrcamento() async {
    widget.orcamento.orcamentoValor = double.parse(_valorController.text);
    widget.orcamento.orcamentoMes = _mesSelecionado;
    widget.orcamento.orcamentoAno = _anoSelecionado;
    final OrcamentoService orcamentoService = OrcamentoService();
    int orcamentoId = await orcamentoService.gravarOrcamento(widget.orcamento);

    // Atualiza o ID do orçamento com o ID retornado pelo serviço
    setState(() {
      widget.orcamento.orcamentoId = orcamentoId;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Orçamento salvo com sucesso!')),
    );
    limparCampos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dados do Orçamento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<int>(
              value: _anoSelecionado,
              items: years.map((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              hint: const Text('Selecione o ano'),
              onChanged: (value) {
                setState(() {
                  _anoSelecionado = value!;
                });
              },
            ),
            DropdownButtonFormField<int>(
              value: _mesSelecionado,
              items: months.map((month) {
                return DropdownMenuItem<int>(
                  value: month,
                  child: Text(month.toString()),
                );
              }).toList(),
              hint: const Text('Selecione o mês'),
              onChanged: (value) {
                setState(() {
                  _mesSelecionado = value!;
                });
              },
            ),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor disponivel'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                salvaOrcamento();
              },
              child: const Text('Gravar'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contas do Orçamento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Soma das contas: R\$$valorGasto"),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: contas.length,
                itemBuilder: (context, index) {
                  final conta = contas[index];
                  return Dismissible(
                    key: Key(conta.contaId.toString()),
                    // direction: DismissDirection.startToEnd,
                    confirmDismiss: (DismissDirection direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: const Text('Deseja excluir este item?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Remover a conta da lista quando arrastada para excluir

                                    removeConta(conta.contaId!);
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Excluir'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (direction == DismissDirection.endToStart) {
                        showDialog(
                          context: context,
                          builder: (context) => dialogDocument(conta),
                        );
                      }
                      return false;
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue, // Cor azul para a outra direção
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.visibility, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(conta.contaDescricao ?? ''),
                      subtitle: Text('Valor: ${conta.contaValor.toString()}'),
                      leading: Icon(conta.contaPago
                          ? Icons.mobile_friendly_sharp
                          : Icons.money_off_rounded),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CadastroContaScreen(conta: conta),
                            ),
                          ).then((value) => _carregarContasDoOrcamento());
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionaConta,
        child: const Text('+ Conta'),
      ),
    );
  }
}
