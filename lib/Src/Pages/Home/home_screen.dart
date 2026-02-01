import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
  final DateTime contractDate;
  final String planName;
  final VoidCallback onLogout;

  const HomeScreen({
    super.key,
    required this.contractDate,
    required this.planName,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = (size.width * 0.05).clamp(16.0, 28.0);

    final scrollPhysics = kIsWeb
        ? const ClampingScrollPhysics()
        : const BouncingScrollPhysics();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const _PremiumBackground(),

          SafeArea(
            child: Column(
              children: [
                // APP BAR PREMIUM
                Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 10),
                  child: _GlassAppBar(
                    left: IconButton(
                      onPressed: widget.onLogout,
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                      tooltip: 'Sair',
                    ),
                    center: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Plataforma',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    right: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _InfoChip(
                          icon: Icons.event_available_rounded,
                          label: _formatDate(widget.contractDate),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2B7CFF), Color(0xFF0B5FFF)],
                          ),
                        ),
                        const SizedBox(width: 10),
                        _InfoChip(
                          icon: Icons.workspace_premium_rounded,
                          label: widget.planName,
                          gradient: _planGradient(widget.planName),
                        ),
                      ],
                    ),
                  ),
                ),

                // CONTEÚDO
                Expanded(
                  child: CustomScrollView(
                    physics: scrollPhysics,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: hPad),
                        sliver: SliverToBoxAdapter(
                          child: _HeroHeader(planName: widget.planName),
                        ),
                      ),

                      // APRESENTAÇÃO
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 0),
                        sliver: const SliverToBoxAdapter(
                          child: _PlatformPresentation(),
                        ),
                      ),

                      // CARDS (Progresso + Sequência)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            children: const [
                              Expanded(child: _ProgressCard()),
                              SizedBox(width: 12),
                              Expanded(child: _StreakCard()),
                            ],
                          ),
                        ),
                      ),

                      // CONTINUAR
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 10),
                        sliver: SliverToBoxAdapter(
                          child: _SectionHeader(
                            title: 'Continuar assistindo',
                            subtitle: 'Retome do ponto exato',
                            actionText: 'Ver tudo',
                            onAction: () {},
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: hPad),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 170,
                            child: ListView.separated(
                              physics: scrollPhysics,
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, i) {
                                return _ContinueCard(
                                  title: 'Aula ${i + 1}: Fundamentos',
                                  course: 'Barber Pro',
                                  progress: (i + 1) * 0.18,
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

                      // MÓDULOS
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 10),
                        sliver: SliverToBoxAdapter(
                          child: _SectionHeader(
                            title: 'Módulos do curso',
                            subtitle: 'Organizado, direto e completo',
                            actionText: 'Explorar',
                            onAction: () {},
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: hPad),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            return _ModuleCard(
                              index: i + 1,
                              title: _moduleTitle(i),
                              lessons: 8 + (i * 2),
                              duration: '${35 + i * 12} min',
                              accent: _moduleAccent(i),
                              onTap: () {},
                            );
                          }, childCount: 6),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: size.width >= 1100
                                    ? 3
                                    : (size.width >= 700 ? 2 : 1),
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: size.width >= 700 ? 2.8 : 2.5,
                              ),
                        ),
                      ),

                      // DESTAQUE
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 10),
                        sliver: SliverToBoxAdapter(
                          child: _SectionHeader(
                            title: 'Destaque da semana',
                            subtitle: 'Aula premium selecionada',
                            actionText: 'Assistir',
                            onAction: () {},
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 130),
                        sliver: SliverToBoxAdapter(
                          child: _FeaturedBanner(
                            title: 'Cortes avançados — execução limpa',
                            subtitle: 'Técnica + padrão profissional',
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM NAV
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: _BottomGlassNav(
              current: navIndex,
              onChange: (index) => setState(() => navIndex = index),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  static LinearGradient _planGradient(String planName) {
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

  static String _moduleTitle(int i) {
    const titles = [
      'Boas-vindas & Setup',
      'Fundamentos',
      'Técnica de corte',
      'Máquina & acabamento',
      'Visagismo',
      'Atendimento & venda',
    ];
    return titles[i % titles.length];
  }

  static Color _moduleAccent(int i) {
    const colors = [
      Color(0xFF54D66A),
      Color(0xFF2B7CFF),
      Color(0xFFFF3B30),
      Color(0xFFFFD400),
      Color(0xFF7C4DFF),
      Color(0xFF00D4FF),
    ];
    return colors[i % colors.length];
  }
}

/// ============================
/// APRESENTAÇÃO DA PLATAFORMA
/// ============================
class _PlatformPresentation extends StatelessWidget {
  const _PlatformPresentation();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plataforma premium. Conteúdo direto. Resultado real.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 19,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Aqui você estuda com padrão profissional: módulos bem estruturados, '
            'aulas objetivas e execução prática. Nada genérico. Nada enrolado.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.76),
              fontWeight: FontWeight.w600,
              fontSize: 13.2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(
                child: _PillarItem(
                  icon: Icons.school_rounded,
                  title: 'Método',
                  text: 'Trilha progressiva do básico ao avançado.',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _PillarItem(
                  icon: Icons.handyman_rounded,
                  title: 'Prática',
                  text: 'Conteúdo aplicável no mundo real.',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _PillarItem(
                  icon: Icons.trending_up_rounded,
                  title: 'Evolução',
                  text: 'Progresso, sequência e consistência.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _PillarItem({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.10),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.70),
            fontSize: 12.2,
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// ============================
/// APP BAR GLASS
/// ============================
class _GlassAppBar extends StatelessWidget {
  final Widget left;
  final Widget center;
  final Widget right;

  const _GlassAppBar({
    required this.left,
    required this.center,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.55),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 48, child: Center(child: left)),
              Expanded(child: Center(child: center)),
              right,
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;

  const _InfoChip({
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
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================
/// HERO
/// ============================
class _HeroHeader extends StatelessWidget {
  final String planName;
  const _HeroHeader({required this.planName});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF54D66A), Color(0xFF2B7CFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2B7CFF).withOpacity(0.35),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vindo de volta.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Seu acesso está ativo: $planName • Bora evoluir com padrão.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _PrimaryCTA(onTap: () {}, text: 'Começar agora'),
        ],
      ),
    );
  }
}

class _PrimaryCTA extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const _PrimaryCTA({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF54D66A), Color(0xFF1E8D33)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF54D66A).withOpacity(0.35),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12.8,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

/// ============================
/// SECTION HEADER
/// ============================
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAction,
  });

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
        GestureDetector(
          onTap: onAction,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Text(
              actionText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ============================
/// GLASS CARD
/// ============================
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

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progresso geral',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.42,
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
          ),
          const SizedBox(height: 10),
          Text(
            '42% concluído • 12 aulas assistidas',
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontWeight: FontWeight.w600,
              fontSize: 12.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFE278), Color(0xFFDB9F07)],
              ),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.black,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sequência',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '6 dias seguidos',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontWeight: FontWeight.w700,
                    fontSize: 12.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final String title;
  final String course;
  final double progress;
  final Color accent;
  final VoidCallback onTap;

  const _ContinueCard({
    required this.title,
    required this.course,
    required this.progress,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 270,
        child: _GlassCard(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                course,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                ),
              ),

              // ✅ sem Spacer (evita problemas em scroll/web)
              const SizedBox(height: 14),

              Stack(
                children: [
                  Container(
                    height: 9,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      height: 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: accent.withOpacity(0.95),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).round()}% • Toque para continuar',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.70),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final int index;
  final String title;
  final int lessons;
  final String duration;
  final Color accent;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.index,
    required this.title,
    required this.lessons,
    required this.duration,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _GlassCard(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [accent.withOpacity(0.95), accent.withOpacity(0.55)],
                ),
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$lessons aulas • $duration',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.68),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.75),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeaturedBanner({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 180,
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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              'Aula premium',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white.withOpacity(0.12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.18),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Assistir agora',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        width: 56,
                        height: 56,
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
                          size: 28,
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
    );
  }
}

/// ============================
/// BOTTOM NAV
/// ============================
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

class _BottomGlassNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onChange;

  const _BottomGlassNav({required this.current, required this.onChange});

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

/// ============================
/// BACKGROUND PREMIUM
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
