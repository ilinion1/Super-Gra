import 'package:flutter/material.dart';

class BlockButton extends ValueNotifier<bool> {
  BlockButton(super.value);

  void changeBlock(bool value) {
    this.value = value;
    notifyListeners();
  }
}

abstract class Provider {
  static final block = BlockButton(false);
}
