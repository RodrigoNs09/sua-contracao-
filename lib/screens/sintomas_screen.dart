import 'package:flutter/material.dart';
import '../data/sintomas_data.dart';
import '../models/registro_sintomas.dart';
import '../services/sintomas_storage.dart';
import '../theme/app_theme.dart';

class SintomasScreen extends StatefulWidget {
  const SintomasScreen({super.key});

  @override
  State<SintomasScreen> createState() => _SintomasScreenState();
}

class _SintomasScreenState extends State<SintomasScreen> {
  int? _humorSelecionado;
  final Set<String> _sintomasSelecionados = {};
  final TextEditingController _pesoController = TextEditingController();
  bool _pesoSalvo = false;

  String _hoje() {
    final agora = DateTime.now();
    return '${agora.year}-${agora.month.toString().padLeft(2, '0')}-${agora.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final dados = await SintomasStorage.carregarRegistros();
    setState(() => listaSintomas = dados);

    final hoje = _hoje();
    final registroHoje = listaSintomas.where((r) => r.data == hoje).toList();
    if (registroHoje.isNotEmpty) {
      final r = registroHoje.first;
      setState(() {
        _humorSelecionado = r.humor;
        _sintomasSelecionados.addAll(r.sintomas);
        if (r.peso != null) {
          _pesoController.text = r.peso.toString();
        }
      });
    }
  }

  Future<void> _salvarRegistroDeHoje() async {
    final hoje = _hoje();
    listaSintomas.removeWhere((r) => r.data == hoje);

    final peso = double.tryParse(_pesoController.text.replaceAll(',', '.'));

    listaSintomas.add(RegistroSintomas(
      data: hoje,
      humor: _humorSelecionado,
      sintomas: _sintomasSelecionados.toList(),
      peso: peso,
    ));

    await SintomasStorage.salvarRegistros(listaSintomas);
  }

  void _selecionarHumor(int index) {
    setState(() => _humorSelecionado = index);
    _salvarRegistroDeHoje();
  }

  void _alternarSintoma(String id) {
    setState(() {
      if (_sintomasSelecionados.contains(id)) {
        _sintomasSelecionados.remove(id);
      } else {
        _sintomasSelecionados.add(id);
      }
    });
    _salvarRegistroDeHoje();
  }

  Future<void> _salvarPeso() async {
    await _salvarRegistroDeHoje();
    setState(() => _pesoSalvo = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _pesoSalvo = false);
  }

  final List<String> _emojisHumor = ['😊', '😐', '😔', '😩', '🤢'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold(context),
      body: Center(
        child: Container(
          width: 300,
          constraints: const BoxConstraints(minHeight: 620),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: AppColors.borderStrong(context), width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant(context),
                  border: Border(bottom: BorderSide(color: AppColors.border(context), width: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left_rounded, color: AppColors.purpleLabel(context), size: 18),
                          const SizedBox(width: 4),
                          Text('Voltar', style: TextStyle(color: AppColors.purpleLabel(context), fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('Diário de hoje',
                        style: TextStyle(color: AppColors.textPrimary(context), fontSize: 20, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 3),
                    Text('Acompanhe seu bem-estar',
                        style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 90),
                  children: [
                    // Card de humor
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border(context), width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('COMO VOCÊ ESTÁ HOJE?',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.textSecondary(context))),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(5, (i) {
                              final selecionado = _humorSelecionado == i;
                              return GestureDetector(
                                onTap: () => _selecionarHumor(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: selecionado ? AppColors.statPurple(context) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: selecionado ? AppTheme.primaryPurple : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(_emojisHumor[i], style: const TextStyle(fontSize: 22)),
                                      const SizedBox(height: 2),
                                      Text(opcoesDeHumor[i],
                                          style: TextStyle(fontSize: 9, color: AppColors.textMuted(context))),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Card de sintomas
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border(context), width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SINTOMAS',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.textSecondary(context))),
                          const SizedBox(height: 4),
                          ...opcoesDeSintomas.map((opcao) {
                            final marcado = _sintomasSelecionados.contains(opcao.id);
                            return InkWell(
                              onTap: () => _alternarSintoma(opcao.id),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: AppColors.statPurple(context), width: 0.5)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(opcao.label, style: TextStyle(fontSize: 13, color: AppColors.textPrimary(context))),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: marcado ? AppTheme.primaryPurple : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: marcado ? AppTheme.primaryPurple : const Color(0xFFD4C0DC),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: marcado
                                          ? const Icon(Icons.check, size: 13, color: Colors.white)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Card de peso
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border(context), width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PESO DE HOJE',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.textSecondary(context))),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _pesoController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary(context)),
                                  decoration: InputDecoration(
                                    hintText: '68.5',
                                    hintStyle: TextStyle(color: AppColors.textMuted(context)),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: AppColors.statPurple(context)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: AppColors.statPurple(context)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: AppTheme.primaryPurple),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('kg', style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _salvarPeso,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _pesoSalvo ? const Color(0xFF1D9E75) : AppTheme.primaryPurple,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  _pesoSalvo ? 'Salvo ✓' : 'Salvar',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}