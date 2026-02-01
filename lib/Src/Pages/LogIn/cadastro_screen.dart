import 'dart:ui';
import 'package:barber_curs/Src/Pages/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cardW = size.width.clamp(320.0, 520.0);
    final cardH = (size.height * 0.44).clamp(330.0, 430.0);

    return Scaffold(
      body: Stack(
        children: [
          // Background (dark + vignette)
          const _DarkVignetteBackground(),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LOGO
                    _LogoHeader(width: cardW * 0.50),

                    const SizedBox(height: 26),

                    // CARD
                    _NeonGlassCard(
                      width: 500,
                      height: 450,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(26, 26, 26, 22),
                        child: Column(
                          children: [
                            const SizedBox(height: 6),

                            _FrostTextField(
                              hint: 'Username / Email',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.person_outline,
                            ),

                            const SizedBox(height: 14),
                            _FrostTextField(
                              hint: 'Name',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.person_outline,
                            ),
                            const SizedBox(height: 14),
                            _FrostTextField(
                              hint: 'Telephone',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.person_outline,
                              maskFilter: MaskFilter.blur(BlurStyle.normal, 3),
                            ),

                            const SizedBox(height: 14),
                            _FrostTextField(
                              hint: 'Password',
                              controller: _passCtrl,
                              obscureText: _obscure,
                              prefixIcon: Icons.lock_outline,
                              suffix: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {},

                                  child: Text(
                                    'Ja Tem Conta? ',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // TODO: navegar para cadastro
                                    context.go('/');
                                  },
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 6, 189, 30),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            _GreenGlowButton(
                              text: 'Entrar',
                              onTap: () {
                                context.go('/plan');
                              },
                            ),

                            const SizedBox(height: 14),

                            Text(
                              'Acesso exclusivo para alunos',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.45),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkVignetteBackground extends StatelessWidget {
  const _DarkVignetteBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base
        Container(color: const Color(0xFF07080C)),

        // Soft noise / texture (fake via gradients)
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, 0.15),
              radius: 1.2,
              colors: [Color(0xFF111320), Color(0xFF07080C)],
              stops: [0.0, 1.0],
            ),
          ),
        ),

        // Vignette overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0),
                radius: 0.95,
                colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
                stops: const [0.55, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoHeader extends StatelessWidget {
  final double width;
  const _LogoHeader({required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width,
          child: AspectRatio(
            aspectRatio: 16 / 7,
            child: Image.asset(
              'assets/logo1.png',
              fit: BoxFit.contain,
              // Se não tiver o asset ainda, comente essa linha e use um Placeholder()
            ),
          ),
        ),
      ],
    );
  }
}

class _NeonGlassCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const _NeonGlassCard({
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = 22.0;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Outer glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 60,
                    spreadRadius: 4,
                    offset: Offset(0, 18),
                    color: Color(0x33FF3B30), // red glow
                  ),
                  BoxShadow(
                    blurRadius: 60,
                    spreadRadius: 4,
                    offset: Offset(0, 18),
                    color: Color(0x332B7CFF), // blue glow
                  ),
                ],
              ),
            ),
          ),

          // Border gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 9, 218, 89),
                    Color.fromARGB(255, 15, 74, 170),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(2.2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius - 2.2),
                child: Stack(
                  children: [
                    // Glass blur
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(
                              borderRadius - 2.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Inner gradient tint (red->blue like the reference)
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.40,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromARGB(255, 9, 218, 89),
                                Color.fromARGB(255, 15, 74, 170),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Subtle highlight
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.10),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content
                    child,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrostTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final MaskFilter? maskFilter;

  const _FrostTextField({
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffix,
    this.maskFilter,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, color: Colors.white70, size: 20),
              suffixIcon: suffix,
            ),
          ),
        ),
      ),
    );
  }
}

class _GreenGlowButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GreenGlowButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF54D66A), Color(0xFF1E8D33)],
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              spreadRadius: 1,
              offset: Offset(0, 10),
              color: Color(0x5500FF66),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
