import 'dart:io';

import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  String label;
  Function callback;
  PrimaryButton({super.key, required this.label, required this.callback});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  var carregando = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: ElevatedButton(
          onPressed: carregando.value
              ? null
              : () async {
                  carregando.value = true;

                  await widget.callback();
                  carregando.value = false;
                },
          child: ValueListenableBuilder<bool>(
            valueListenable: carregando,
            builder: (context, value, child) {
              if (value) {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                );
              } else {
                return Text(widget.label);
              }
            },
          ),
        ),
      ),
    );
  }
}
