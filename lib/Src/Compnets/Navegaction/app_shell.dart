import 'package:flutter/material.dart';
import 'package:barber_curs/Src/Compnets/Navegaction/bottom_glass_nav.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTapIndex;

  final DateTime contractDate;
  final String planName;
  final VoidCallback onLogout;

  const AppShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTapIndex,
    required this.contractDate,
    required this.planName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ⚠️ Importante: o child não precisa ser Scaffold
      body: Stack(
        children: [
          // Se você quiser seu background premium aqui depois, coloca.
          // Por enquanto simples:
          Container(color: const Color(0xFF05060A)),

          SafeArea(
            child: Column(
              children: [
                // Se quiser manter AppBar premium global, coloca aqui.
                // Senão, deixa cada tela cuidar do topo.
                Expanded(child: child),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: BottomGlassNav(current: currentIndex, onChange: onTapIndex),
          ),
        ],
      ),
    );
  }
}
