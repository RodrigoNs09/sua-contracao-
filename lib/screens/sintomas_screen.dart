import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SintomasScreen extends StatelessWidget {
  const SintomasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😊', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Diário de Sintomas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Em construção...',
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          ],
        ),
      ),
    );
  }
}