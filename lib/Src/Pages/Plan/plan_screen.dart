import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PlanType { basico, gold, platinum }

class Planescreen extends StatefulWidget {
  const Planescreen({super.key});

  @override
  State<Planescreen> createState() => _PlanescreenState();
}

class _PlanescreenState extends State<Planescreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _TopGlassBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 34,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: size.height * 0.90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlipPlanCard(
                        width: 290,
                        height: 490,
                        planType: PlanType.basico,
                        frontImage: 'assets/basico.png',
                        backImage: 'assets/fundoBasico.png',
                        planName: 'Plano Básico',
                        priceText: 'R\$ 19,90/mês',
                        onBuy: () => context.go('/home'),
                      ),
                      const SizedBox(width: 18),
                      FlipPlanCard(
                        width: 280,
                        height: 490,
                        planType: PlanType.gold,
                        frontImage: 'assets/gold.png',
                        backImage: 'assets/fundoGold.png',
                        planName: 'Plano Gold',
                        priceText: 'R\$ 59,90/mês',
                        onBuy: () => context.go('/home'),
                      ),
                      const SizedBox(width: 18),
                      FlipPlanCard(
                        width: 290,
                        height: 490,
                        planType: PlanType.platinum,
                        frontImage: 'assets/platinum.png',
                        backImage: 'assets/fundoPlatinum.png',
                        planName: 'Plano Platinum',
                        priceText: 'R\$ 199,90/mês',
                        onBuy: () => context.go('/home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

/// ============================
/// TOP BAR (GLASS)
/// ============================
class _TopGlassBar extends StatelessWidget {
  final Widget child;
  const _TopGlassBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// ============================
/// FLIP PLAN CARD
/// ============================
class FlipPlanCard extends StatefulWidget {
  final String frontImage;
  final String backImage;
  final double width;
  final double height;
  final PlanType planType;

  final String planName;
  final String priceText;
  final VoidCallback onBuy;

  const FlipPlanCard({
    super.key,
    required this.frontImage,
    required this.backImage,
    required this.width,
    required this.height,
    required this.planType,
    required this.planName,
    required this.priceText,
    required this.onBuy,
  });

  @override
  State<FlipPlanCard> createState() => _FlipPlanCardState();
}

class _FlipPlanCardState extends State<FlipPlanCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isFront = true;

  // ✅ mesmo posicionamento do botão no _BackFace
  static const double _btnTop = 395;
  static const double _btnRight = 75;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  void _flip() {
    if (_controller.isAnimating) return;

    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    setState(() => _isFront = !_isFront);
  }

  bool _tapIsOnBuyButton(Offset localPos) {
    // retângulo do botão dentro do card
    final btnRect = Rect.fromLTWH(
      (widget.width - _btnRight - BuyButton.w),
      _btnTop,
      BuyButton.w,
      BuyButton.h,
    );
    return btnRect.contains(localPos);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * pi;
        final isBackVisible = angle > pi / 2;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,

          // ✅ flip só se NÃO for toque no botão
          onTapUp: (d) {
            if (isBackVisible && _tapIsOnBuyButton(d.localPosition)) return;
            _flip();
          },

          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(angle),
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: isBackVisible
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: _BackFace(
                          image: widget.backImage,
                          planName: widget.planName,
                          priceText: widget.priceText,
                          planType: widget.planType,
                          onBuy: widget.onBuy,
                          btnTop: _btnTop,
                          btnRight: _btnRight,
                        ),
                      )
                    : _FrontFace(image: widget.frontImage),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// =========================
/// Frente (somente imagem)
/// =========================
class _FrontFace extends StatelessWidget {
  final String image;
  const _FrontFace({required this.image});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.08),
      colorBlendMode: BlendMode.darken,
    );
  }
}

/// =========================
/// Verso (imagem + botão + barra inferior)
/// =========================
class _BackFace extends StatelessWidget {
  final String image;
  final String planName;
  final String priceText;
  final VoidCallback onBuy;
  final PlanType planType;

  final double btnTop;
  final double btnRight;

  const _BackFace({
    required this.image,
    required this.planName,
    required this.priceText,
    required this.onBuy,
    required this.planType,
    required this.btnTop,
    required this.btnRight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.12),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 25,
          child: _BottomInfoBar(title: planName, price: priceText),
        ),
        Positioned(
          top: btnTop,
          right: btnRight,
          child: BuyButton(planType: planType, onPressed: onBuy),
        ),
      ],
    );
  }
}

/// =========================
/// BOTÃO ASSINAR
/// =========================
class BuyButton extends StatefulWidget {
  static const double w = 140;
  static const double h = 44;

  final VoidCallback onPressed;
  final PlanType planType;

  const BuyButton({super.key, required this.onPressed, required this.planType});

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final style = _planStyle(widget.planType);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.96 : 1.0,
        child: SizedBox(
          width: BuyButton.w,
          height: BuyButton.h,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: style.gradient,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
              boxShadow: [
                BoxShadow(
                  color: style.glow.withOpacity(0.55),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 12,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: style.textColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Assinar',
                  style: TextStyle(
                    color: style.textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanButtonStyle {
  final List<Color> gradient;
  final Color glow;
  final Color textColor;

  const _PlanButtonStyle({
    required this.gradient,
    required this.glow,
    required this.textColor,
  });
}

_PlanButtonStyle _planStyle(PlanType type) {
  switch (type) {
    case PlanType.basico:
      return const _PlanButtonStyle(
        gradient: [Color(0xFFFF4B4B), Color(0xFFB3001B)],
        glow: Color(0xFFFF3B30),
        textColor: Colors.white,
      );
    case PlanType.gold:
      return const _PlanButtonStyle(
        gradient: [Color(0xFFFFE278), Color(0xFFDB9F07)],
        glow: Color(0xFFFFD400),
        textColor: Colors.black,
      );
    case PlanType.platinum:
      return const _PlanButtonStyle(
        gradient: [Color(0xFF0E80F1), Color(0xFF0847AC)],
        glow: Color(0xFF2B7CFF),
        textColor: Colors.white,
      );
  }
}

/// =========================
/// BARRA DE INFO
/// =========================
class _BottomInfoBar extends StatelessWidget {
  final String title;
  final String price;

  const _BottomInfoBar({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.12)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Acesso completo + bônus',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
