import 'package:flutter/material.dart';

/// Widget reutilizável para exibir o logo do AppEAO
/// com a placa de obra preta e texto amarelo
class AppLogo extends StatelessWidget {
  final double width;
  final double height;
  final double fontSize;
  final double subtitleFontSize;
  final bool showStripes;
  
  const AppLogo({
    super.key,
    this.width = 200,
    this.height = 140,
    this.fontSize = 36,
    this.subtitleFontSize = 14,
    this.showStripes = true,
  });

  /// Logo pequeno (para headers, appbars, etc)
  const AppLogo.small({
    super.key,
    this.width = 100,
    this.height = 70,
    this.fontSize = 20,
    this.subtitleFontSize = 10,
    this.showStripes = false,
  });

  /// Logo médio (para telas de login/registro)
  const AppLogo.medium({
    super.key,
    this.width = 150,
    this.height = 105,
    this.fontSize = 28,
    this.subtitleFontSize = 12,
    this.showStripes = true,
  });

  /// Logo grande (para tela de loading)
  const AppLogo.large({
    super.key,
    this.width = 200,
    this.height = 140,
    this.fontSize = 36,
    this.subtitleFontSize = 14,
    this.showStripes = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nome do App
          Text(
            'AppEAO',
            style: TextStyle(
              color: const Color(0xFFFFD700),
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: height * 0.05),
          // Subtítulo
          Text(
            'MÃO DE OBRA',
            style: TextStyle(
              color: const Color(0xFFFFD700),
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 3,
            ),
          ),
          // Listras de obra (opcional)
          if (showStripes) ...[
            SizedBox(height: height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                8,
                (index) => Container(
                  width: width * 0.1,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? const Color(0xFFFFD700)
                        : Colors.black,
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

