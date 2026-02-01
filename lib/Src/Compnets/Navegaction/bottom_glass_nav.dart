import 'dart:ui';
import 'package:flutter/material.dart';

class BottomGlassNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onChange;

  const BottomGlassNav({
    super.key,
    required this.current,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavIcon(
                  icon: Icons.nfc_rounded,
                  active: current == 0,
                  onTap: () => onChange(0),
                ),
                _NavIcon(
                  icon: Icons.menu_rounded,
                  active: current == 1,
                  onTap: () => onChange(1),
                ),
                _HomeCenterButton(
                  active: current == 2,
                  onTap: () => onChange(2),
                ),
                _NavIcon(
                  icon: Icons.play_arrow_rounded,
                  active: current == 3,
                  onTap: () => onChange(3),
                ),
                _NavIcon(
                  icon: Icons.person_rounded,
                  active: current == 4,
                  onTap: () => onChange(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeCenterButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _HomeCenterButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.14),
          border: Border.all(color: Colors.white.withOpacity(0.20)),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(Icons.home_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: active
              ? Border.all(color: Colors.white.withOpacity(0.18))
              : null,
        ),
        child: Icon(
          icon,
          color: active ? Colors.white : Colors.white70,
          size: 24,
        ),
      ),
    );
  }
}
