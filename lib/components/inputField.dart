// ignore_for_file: file_names

import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  TextEditingController ctrl = TextEditingController();
  String label;
  TextInputType? tipoTeclado;
  InputField(
      {super.key, required this.ctrl, required this.label, this.tipoTeclado});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: widget.ctrl,
        keyboardType: widget.tipoTeclado ?? TextInputType.text,
        decoration: InputDecoration(
            label: Text(widget.label), border: const OutlineInputBorder()),
      ),
    );
  }
}
