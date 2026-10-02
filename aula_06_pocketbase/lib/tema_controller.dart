import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemaController {
  final SharedPreferencesAsync prefs;
  final tema = ValueNotifier<ThemeMode>(ThemeMode.light);
  bool _salvando = false;
  TemaController(this.prefs);

  Future<void> carregar() async {
    final valor = await prefs.getString('tema');
    tema.value = valor == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> alternar() async {
    if (_salvando) return;
    _salvando = true;
    try {
      final novo = tema.value == ThemeMode.light
          ? ThemeMode.dark : ThemeMode.light;
      await prefs.setString('tema', novo == ThemeMode.dark ? 'dark' : 'light');
      tema.value = novo;
    } finally {
      _salvando = false;
    }
  }

  void dispose() => tema.dispose();
}
