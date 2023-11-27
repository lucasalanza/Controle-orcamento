import 'dart:io';
import 'dart:typed_data';
import 'package:controleOrcamentos/services/contaService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/contaModel.dart';

class CadastroContaScreen extends StatefulWidget {
  final ContaModel conta;

  const CadastroContaScreen({Key? key, required this.conta}) : super(key: key);

  @override
  _CadastroContaScreenState createState() => _CadastroContaScreenState();
}

class _CadastroContaScreenState extends State<CadastroContaScreen> {
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();
  bool _contaPago = false;
  Uint8List arquivoImagem = Uint8List(0);

  ImagePicker _imagePicker = ImagePicker();

  void _adicionarImagemComprovante() async {
    final XFile? imagemSelecionada =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imagemSelecionada != null) {
      setState(() {
        arquivoImagem = File(imagemSelecionada.path).readAsBytesSync();
      });
    }
  }

  Future<void> _salvarConta() async {
    try {
      int orcamentoId =
          widget.conta.orcamentoId; // Obtém o ID do orçamento dos parâmetros
      int? contaId = widget.conta.contaId;
      String descricao = _descricaoController.text;
      double valor = double.tryParse(_valorController.text) ?? 0.0;
      ContaModel conta = ContaModel(
          contaId, descricao, _contaPago, arquivoImagem, valor, orcamentoId);
      // Chama o serviço para salvar a conta
      await ContaService().salvarConta(conta);

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta salva com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Limpa os campos após salvar
      _descricaoController.clear();
      _valorController.clear();
      setState(() {
        _contaPago = false;
        arquivoImagem = Uint8List(0);
      });
    } catch (e) {
      // Exibe uma mensagem de erro se ocorrer uma exceção
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar a conta: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descricaoController =
        TextEditingController(text: widget.conta.contaDescricao ?? '');
    _valorController =
        TextEditingController(text: widget.conta.contaValor.toString());

    _contaPago = widget.conta.contaPago;
    arquivoImagem = widget.conta.contaRecibo ?? Uint8List(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descricaoController,
              decoration:
                  const InputDecoration(labelText: 'Descrição da Conta'),
            ),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor da Conta'),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title: const Text('Conta Paga'),
              value: _contaPago,
              onChanged: (bool? value) {
                setState(() {
                  _contaPago = !_contaPago;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _adicionarImagemComprovante();
              },
              child: const Text('Adicionar Imagem do Comprovante'),
            ),
            arquivoImagem.isNotEmpty
                ? Image.memory(
                    arquivoImagem,
                    width: 200,
                  )
                : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarConta,
              child: const Text('Salvar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
