import 'package:controleOrcamentos/models/contaModel.dart';
import 'package:controleOrcamentos/models/temaModel.dart';
import 'package:controleOrcamentos/models/orcamentoModel.dart';
import 'package:controleOrcamentos/screens/CadastroOrcamentoScreen.dart';
import 'package:controleOrcamentos/services/orcamentoService.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OrcamentoService orcamentoService = OrcamentoService();
  List<OrcamentoModel> listaOrcamentos = [];

  void carregarOrcamentos() async {
    var lista = await orcamentoService.listarOrcamentos();

    setState(() {
      listaOrcamentos = lista;
    });
  }

  Future<bool> excluirOrcamento(int id) async {
    return orcamentoService.deletarOrcamento(id);
  }

  @override
  void initState() {
    super.initState();
    carregarOrcamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Row(
            children: [
              const Text("Modo escuro"),
              Switch(
                onChanged: (value) {
                  setState(() {
                    TemaModel.singleton.mudarTema();
                  });
                },
                value: TemaModel.singleton.modoEscuro,
              ),
            ],
          ),
        ],
        title: const Text(
          "Controle de contas",
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: listaOrcamentos.length,
        itemBuilder: (context, index) {
          // Cálculo do valor atual do orçamento (soma das contas)
          int contasCadastradas = listaOrcamentos[index].contas.length;
          double valorAtualOrcamento = 0.0;

          for (ContaModel conta in listaOrcamentos[index].contas) {
            valorAtualOrcamento += conta.contaValor;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dismissible(
              key: UniqueKey(),
              confirmDismiss: (DismissDirection direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmar exclusão'),
                        content: const Text('Deseja excluir este item?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              excluirOrcamento(
                                  listaOrcamentos[index].orcamentoId!);
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Excluir'),
                          ),
                        ],
                      );
                    },
                  );
                }
                return false;
              },
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  OrcamentoModel orcamentoSelecionado = listaOrcamentos[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroOrcamentoScreen(
                        orcamento: orcamentoSelecionado,
                      ),
                    ),
                  ).then((value) => carregarOrcamentos());
                },
                child: Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                'Ano:${listaOrcamentos[index].orcamentoAno}',
                              ),
                              Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                'Mes:${listaOrcamentos[index].orcamentoMes}',
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Gasto Estimado: R\$ ${listaOrcamentos[index].orcamentoValor}',
                        ),
                        Text(
                          'Gastos até o momento: R\$ $valorAtualOrcamento',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Contas: $contasCadastradas',
                        ),
                        // Outras informações do orçamento, se necessário
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          OrcamentoModel novoOrcamento = OrcamentoModel(
              null, 0, DateTime.now().month, DateTime.now().year, []);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastroOrcamentoScreen(
                orcamento: novoOrcamento,
              ),
            ),
          ).then((value) => carregarOrcamentos());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
