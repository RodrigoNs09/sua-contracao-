import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chute_sessao.dart';

class ChutesStorage {
  static const String _key = 'sessoes_chutes';

  static Future<void> salvarSessoes(List<ChuteSessao> sessoes) async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = sessoes.map((s) => jsonEncode(s.toMap())).toList();
    await prefs.setStringList(_key, listaJson);
  }

  static Future<List<ChuteSessao>> carregarSessoes() async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = prefs.getStringList(_key) ?? [];
    return listaJson.map((item) => ChuteSessao.fromMap(jsonDecode(item))).toList();
  }
}