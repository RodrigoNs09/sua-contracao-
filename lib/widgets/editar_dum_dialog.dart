import 'package:flutter/material.dart';
import '../data/gestacao_data.dart';
import '../services/gestacao_storage.dart';
import '../theme/app_theme.dart';

Future<void> mostrarEditarDUM(BuildContext context, VoidCallback aoSalvar) async {
  DateTime dataEscolhida = gestacaoAtual.dum;

  final resultado = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface(ctx),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.border(ctx),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  'Editar data da gestação',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(ctx),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Informe a data da última menstruação (DUM)',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary(ctx)),
                ),
                const SizedBox(height: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () async {
                    final novaData = await showDatePicker(
                      context: ctx,
                      initialDate: dataEscolhida,
                      firstDate: DateTime.now().subtract(const Duration(days: 300)),
                      lastDate: DateTime.now(),
                      helpText: 'Data da última menstruação',
                      cancelText: 'Cancelar',
                      confirmText: 'OK',
                    );
                    if (novaData != null) {
                      setModalState(() => dataEscolhida = novaData);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.statPurple(ctx),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 18, color: AppTheme.primaryPurple),
                        const SizedBox(width: 10),
                        Text(
                          '${dataEscolhida.day.toString().padLeft(2, '0')}/'
                          '${dataEscolhida.month.toString().padLeft(2, '0')}/'
                          '${dataEscolhida.year}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary(ctx),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.border(ctx)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('Cancelar', style: TextStyle(color: AppColors.textPrimary(ctx))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Salvar', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (resultado == true) {
    atualizarDUM(dataEscolhida);
    await GestacaoStorage.salvarDUM(dataEscolhida);
    aoSalvar();
  }
}