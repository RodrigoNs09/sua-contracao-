import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/registro_sintomas.dart';

class SintomasStorage {
  static const String _key = 'registros_sintomas';

  static Future<void> salvarRegistros(List<RegistroSintomas> registros) async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = registros.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList(_key, listaJson);
  }

  static Future<List<RegistroSintomas>> carregarRegistros() async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = prefs.getStringList(_key) ?? [];
    return listaJson.map((item) => RegistroSintomas.fromMap(jsonDecode(item))).toList();
  }
}