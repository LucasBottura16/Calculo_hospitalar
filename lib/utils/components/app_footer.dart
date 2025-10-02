import 'package:calculo_imc/utils/colors.dart';
import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: MyColors.myPrimary,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(124, 0, 0, 0).withValues(),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.copyright, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '2025 Bottura Tech. Todos os direitos reservados.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
