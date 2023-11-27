

import 'package:flutter/material.dart';

class TemaModel extends ChangeNotifier {

  //singleton
  static TemaModel singleton = TemaModel();
  bool modoEscuro = true;

  void mudarTema() {
    modoEscuro = !modoEscuro;

    notifyListeners();
  }
}