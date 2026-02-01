import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// ============================
/// ONLINE LESSON SCREEN (Premium)
/// ============================
class OnlineLessonScreen extends StatefulWidget {
  final String planName;
  final String courseName;
  final String moduleName;
  final String lessonTitle;
  final DateTime contractDate;

  const OnlineLessonScreen({
    super.key,
    required this.planName,
    required this.courseName,
    required this.moduleName,
    required this.lessonTitle,
    required this.contractDate,
  });

  @override
  State<OnlineLessonScreen> createState() => _OnlineLessonScreenState();
}

class _OnlineLessonScreenState extends State<OnlineLessonScreen> {
  double progress = 0.32;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = (size.width * 0.05).clamp(16.0, 28.0);

    final physics = kIsWeb
        ? const ClampingScrollPhysics()
        : const BouncingScrollPhysics();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const _PremiumBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: physics,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 10),
                  sliver: SliverToBoxAdapter(
                    child: _GlassTopBar(
                      left: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        tooltip: 'Voltar',
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      title: 'Aula online',
                      subtitle: 'Assista e evolua no padrão',
                      right: _MiniChip(
                        icon: Icons.workspace_premium_rounded,
                        label: widget.planName,
                        gradient: PlanUi.gradient(widget.planName),
                      ),
                    ),
                  ),
                ),

                // PLAYER
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: _VideoPlayerCard(
                      courseName: widget.courseName,
                      moduleName: widget.moduleName,
                      lessonTitle: widget.lessonTitle,
                      onPlay: () {},
                    ),
                  ),
                ),

                // INFO + AÇÕES
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 0),
                  sliver: SliverToBoxAdapter(
                    child: _GlassCard(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.lessonTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${widget.courseName} • ${widget.moduleName} • 28 min',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.72),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.6,
                            ),
                          ),
                          const SizedBox(height: 14),

                          _ProgressLine(value: progress),

                          const SizedBox(height: 10),
                          Text(
                            '${(progress * 100).round()}% assistido • retome do ponto exato',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.70),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.3,
                            ),
                          ),
                          const SizedBox(height: 14),

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _PrimaryButton(
                                icon: Icons.play_arrow_rounded,
                                text: 'Continuar',
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF54D66A),
                                    Color(0xFF1E8D33),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    progress = (progress + 0.08).clamp(0, 1);
                                  });
                                },
                              ),
                              _SecondaryButton(
                                icon: Icons.download_rounded,
                                text: 'Baixar',
                                onTap: () {},
                              ),
                              _SecondaryButton(
                                icon: Icons.folder_copy_rounded,
                                text: 'Materiais',
                                onTap: () {},
                              ),
                              _SecondaryButton(
                                icon: Icons.chat_bubble_rounded,
                                text: 'Dúvidas',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // PRÓXIMAS AULAS
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 10),
                  sliver: const SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Próximas aulas',
                      subtitle: 'Continue a trilha sem perder ritmo',
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 150,
                      child: ListView.separated(
                        physics: physics,
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          return _NextLessonCard(
                            index: i + 1,
                            title: 'Aula ${i + 2}: Técnica e acabamento',
                            duration: '${18 + i * 3} min',
                            accent: i.isEven
                                ? const Color(0xFF2B7CFF)
                                : const Color(0xFF54D66A),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // NOTAS / CHECKLIST
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 10),
                  sliver: const SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Notas rápidas',
                      subtitle: 'Anote o que importa (sem enrolação)',
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: _GlassCard(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Checklist da aula',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _CheckRow(
                            text: 'Pegada correta da máquina',
                            done: true,
                          ),
                          _CheckRow(text: 'Linha guia e simetria', done: false),
                          _CheckRow(text: 'Acabamento + limpeza', done: false),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withOpacity(0.06),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.12),
                              ),
                            ),
                            child: Text(
                              'Dica: repita 3x a parte do acabamento até ficar automático.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.72),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.4,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================
/// VIDEO PLAYER CARD
/// ============================
class _VideoPlayerCard extends StatelessWidget {
  final String courseName;
  final String moduleName;
  final String lessonTitle;
  final VoidCallback onPlay;

  const _VideoPlayerCard({
    required this.courseName,
    required this.moduleName,
    required this.lessonTitle,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 220,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B7CFF), Color(0xFF54D66A), Color(0xFFFF3B30)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.16)),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            courseName,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.78),
                              fontWeight: FontWeight.w800,
                              fontSize: 12.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lessonTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            moduleName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.80),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _PrimaryButton(
                            icon: Icons.play_arrow_rounded,
                            text: 'Assistir agora',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF54D66A), Color(0xFF1E8D33)],
                            ),
                            onTap: onPlay,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: const Icon(
                        Icons.ondemand_video_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================
/// SMALL WIDGETS
/// ============================
class _ProgressLine extends StatelessWidget {
  final double value;
  const _ProgressLine({required this.value});

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Stack(
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        FractionallySizedBox(
          widthFactor: v,
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                colors: [Color(0xFF54D66A), Color(0xFF2B7CFF)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Gradient gradient;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.icon,
    required this.text,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.10),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextLessonCard extends StatelessWidget {
  final int index;
  final String title;
  final String duration;
  final Color accent;
  final VoidCallback onTap;

  const _NextLessonCard({
    required this.index,
    required this.title,
    required this.duration,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 260,
        child: _GlassCard(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: accent.withOpacity(0.18),
                      border: Border.all(color: accent.withOpacity(0.35)),
                    ),
                    child: Center(
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      duration,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.70),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.2,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Toque para abrir',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.62),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String text;
  final bool done;

  const _CheckRow({required this.text, required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: done
                  ? const Color(0xFF54D66A)
                  : Colors.white.withOpacity(0.10),
              border: Border.all(
                color: done
                    ? const Color(0xFF54D66A).withOpacity(0.55)
                    : Colors.white.withOpacity(0.14),
              ),
            ),
            child: Icon(
              done ? Icons.check_rounded : Icons.circle_outlined,
              size: 16,
              color: done ? Colors.black : Colors.white70,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.82),
                fontWeight: FontWeight.w700,
                fontSize: 12.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================
/// TOP BAR + SECTION
/// ============================
class _GlassTopBar extends StatelessWidget {
  final Widget left;
  final String title;
  final String subtitle;
  final Widget right;

  const _GlassTopBar({
    required this.left,
    required this.title,
    required this.subtitle,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          SizedBox(width: 48, child: Center(child: left)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.62),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          right,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.62),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ============================
/// MINI CHIP + GLASS CARD
/// ============================
class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;

  const _MiniChip({
    required this.icon,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  gradient: gradient,
                ),
                child: Icon(icon, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.55),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// ============================
/// PREMIUM BACKGROUND
/// ============================
class _PremiumBackground extends StatelessWidget {
  const _PremiumBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFF05060A)),
        Positioned.fill(
          child: Opacity(
            opacity: 0.22,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.85, -0.15),
                  radius: 1.1,
                  colors: [Color(0xFF54D66A), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.22,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.9, -0.1),
                  radius: 1.1,
                  colors: [Color(0xFF2B7CFF), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0.05),
                radius: 0.95,
                colors: [Colors.transparent, Colors.black.withOpacity(0.78)],
                stops: const [0.55, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ============================
/// PLAN UI (shared)
/// ============================
class PlanUi {
  static LinearGradient gradient(String planName) {
    final p = planName.toLowerCase();
    if (p.contains('plat')) {
      return const LinearGradient(
        colors: [Color(0xFF2B7CFF), Color(0xFF0B5FFF)],
      );
    }
    if (p.contains('gold')) {
      return const LinearGradient(
        colors: [Color(0xFFFFE278), Color(0xFFDB9F07)],
      );
    }
    return const LinearGradient(colors: [Color(0xFFFF4B4B), Color(0xFFB3001B)]);
  }
}
