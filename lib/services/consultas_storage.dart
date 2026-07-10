import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/consulta.dart';

class ConsultasStorage {
  static const String _key = 'consultas_agendadas';

  static Future<void> salvarConsultas(List<Consulta> consultas) async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = consultas.map((c) => jsonEncode(c.toMap())).toList();
    await prefs.setStringList(_key, listaJson);
  }

  static Future<List<Consulta>> carregarConsultas() async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = prefs.getStringList(_key) ?? [];
    return listaJson.map((item) => Consulta.fromMap(jsonDecode(item))).toList();
  }
}