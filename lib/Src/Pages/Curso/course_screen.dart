import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// ============================
/// MODELOS (simples e práticos)
/// ============================
class LessonItem {
  final String id;
  final String title;
  final Duration duration;
  final bool isLocked;
  final bool isWatched;

  const LessonItem({
    required this.id,
    required this.title,
    required this.duration,
    this.isLocked = false,
    this.isWatched = false,
  });
}

class ModuleItem {
  final String id;
  final String title;
  final List<LessonItem> lessons;

  const ModuleItem({
    required this.id,
    required this.title,
    required this.lessons,
  });
}

/// ============================
/// TELA PRINCIPAL (Player + Sidebar)
/// ============================
class CoursePlayerScreen extends StatefulWidget {
  const CoursePlayerScreen({super.key});

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedModuleIndex = 0;
  int selectedLessonIndex = 0;

  // Mock (troca depois pelo seu backend)
  late final List<ModuleItem> modules = _mockModules();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final hPad = (size.width * 0.05).clamp(16.0, 28.0);

    final isWide = size.width >= 980; // desktop/tablet wide
    final scrollPhysics = kIsWeb
        ? const ClampingScrollPhysics()
        : const BouncingScrollPhysics();

    final currentModule = modules[selectedModuleIndex];
    final currentLesson = currentModule.lessons[selectedLessonIndex];

    // Conteúdo principal (lado esquerdo)
    Widget buildContent({required VoidCallback? onOpenModules}) {
      return CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 12),
            sliver: SliverToBoxAdapter(
              child: _HeaderBar(
                title: 'Barber Pro • Área do Aluno',
                subtitle: 'Continue do ponto exato e evolua com padrão.',
                onOpenModules: onOpenModules,
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            sliver: SliverToBoxAdapter(
              child: _VideoPlayerCard(
                lessonTitle: currentLesson.title,
                moduleTitle: currentModule.title,
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 0),
            sliver: SliverToBoxAdapter(
              child: _LessonMetaRow(
                duration: currentLesson.duration,
                watched: currentLesson.isWatched,
                locked: currentLesson.isLocked,
                onPrev: _canPrev() ? _goPrev : null,
                onNext: _canNext() ? _goNext : null,
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 24),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, c) {
                  final stack = c.maxWidth < 720;
                  if (stack) {
                    return Column(
                      children: const [
                        _InfoGlassCard(
                          title: 'Resumo da aula',
                          text:
                              'Aqui você coloca a descrição do vídeo, materiais e o que o aluno precisa executar na prática.',
                          icon: Icons.description_rounded,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2B7CFF), Color(0xFF0B5FFF)],
                          ),
                        ),
                        SizedBox(height: 12),
                        _InfoGlassCard(
                          title: 'Materiais',
                          text:
                              '• Máquina\n• Pentes\n• Tesoura\n• Navalha\n• Pó / Spray',
                          icon: Icons.inventory_2_rounded,
                          gradient: LinearGradient(
                            colors: [Color(0xFF54D66A), Color(0xFF1E8D33)],
                          ),
                        ),
                      ],
                    );
                  }

                  return const Row(
                    children: [
                      Expanded(
                        child: _InfoGlassCard(
                          title: 'Resumo da aula',
                          text:
                              'Aqui você coloca a descrição do vídeo, materiais e o que o aluno precisa executar na prática.',
                          icon: Icons.description_rounded,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2B7CFF), Color(0xFF0B5FFF)],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _InfoGlassCard(
                          title: 'Materiais',
                          text:
                              '• Máquina\n• Pentes\n• Tesoura\n• Navalha\n• Pó / Spray',
                          icon: Icons.inventory_2_rounded,
                          gradient: LinearGradient(
                            colors: [Color(0xFF54D66A), Color(0xFF1E8D33)],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 110),
            sliver: SliverToBoxAdapter(
              child: _NextUpCard(
                nextLabel: _nextUpLabel(),
                onTap: _canNext() ? _goNext : null,
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        const _PremiumBackground(),

        SafeArea(
          child: isWide
              ? Row(
                  children: [
                    Expanded(child: buildContent(onOpenModules: null)),
                    SizedBox(
                      width: 380,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 14, hPad, 14),
                        child: _ModulesSidebar(
                          modules: modules,
                          selectedModuleIndex: selectedModuleIndex,
                          selectedLessonIndex: selectedLessonIndex,
                          onSelect: _selectLesson,
                        ),
                      ),
                    ),
                  ],
                )
              : Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: Colors.transparent,
                  endDrawerEnableOpenDragGesture: true,
                  endDrawer: Drawer(
                    backgroundColor: Colors.transparent,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: _ModulesSidebar(
                          modules: modules,
                          selectedModuleIndex: selectedModuleIndex,
                          selectedLessonIndex: selectedLessonIndex,
                          onSelect: (mi, li) {
                            _selectLesson(mi, li);
                            Navigator.of(context).pop(); // fecha drawer
                          },
                        ),
                      ),
                    ),
                  ),
                  body: buildContent(
                    onOpenModules: () =>
                        _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ),
        ),
      ],
    );
  }

  // ============================
  // CONTROLE DE AULA
  // ============================
  void _selectLesson(int moduleIndex, int lessonIndex) {
    setState(() {
      selectedModuleIndex = moduleIndex;
      selectedLessonIndex = lessonIndex;
    });
  }

  bool _canPrev() {
    if (selectedLessonIndex > 0) return true;
    return selectedModuleIndex > 0;
  }

  bool _canNext() {
    final module = modules[selectedModuleIndex];
    if (selectedLessonIndex < module.lessons.length - 1) return true;
    return selectedModuleIndex < modules.length - 1;
  }

  void _goPrev() {
    setState(() {
      if (selectedLessonIndex > 0) {
        selectedLessonIndex--;
      } else if (selectedModuleIndex > 0) {
        selectedModuleIndex--;
        selectedLessonIndex = modules[selectedModuleIndex].lessons.length - 1;
      }
    });
  }

  void _goNext() {
    setState(() {
      final module = modules[selectedModuleIndex];
      if (selectedLessonIndex < module.lessons.length - 1) {
        selectedLessonIndex++;
      } else if (selectedModuleIndex < modules.length - 1) {
        selectedModuleIndex++;
        selectedLessonIndex = 0;
      }
    });
  }

  String _nextUpLabel() {
    if (!_canNext()) return 'Você concluiu todas as aulas 🎯';
    final module = modules[selectedModuleIndex];
    if (selectedLessonIndex < module.lessons.length - 1) {
      return module.lessons[selectedLessonIndex + 1].title;
    }
    return modules[selectedModuleIndex + 1].lessons.first.title;
  }

  // ============================
  // MOCK DATA (5 módulos)
  // ============================
  List<ModuleItem> _mockModules() {
    Duration m(int minutes) => Duration(minutes: minutes);

    return [
      ModuleItem(
        id: 'm1',
        title: 'Módulo 1 — Boas-vindas & Setup',
        lessons: const [
          LessonItem(
            id: 'l1',
            title: 'Introdução e padrão profissional',
            duration: Duration(minutes: 8),
            isWatched: true,
          ),
          LessonItem(
            id: 'l2',
            title: 'Organizando sua estação de trabalho',
            duration: Duration(minutes: 12),
          ),
          LessonItem(
            id: 'l3',
            title: 'Ferramentas essenciais',
            duration: Duration(minutes: 10),
          ),
        ],
      ),
      ModuleItem(
        id: 'm2',
        title: 'Módulo 2 — Fundamentos',
        lessons: [
          LessonItem(id: 'l4', title: 'Divisões e marcação', duration: m(14)),
          LessonItem(
            id: 'l5',
            title: 'Controle de máquina (pegada e ângulo)',
            duration: m(16),
          ),
          LessonItem(
            id: 'l6',
            title: 'Finalização e simetria',
            duration: m(12),
          ),
        ],
      ),
      ModuleItem(
        id: 'm3',
        title: 'Módulo 3 — Técnica de corte',
        lessons: [
          LessonItem(id: 'l7', title: 'Fade limpo do zero', duration: m(22)),
          LessonItem(
            id: 'l8',
            title: 'Degradê com transição suave',
            duration: m(18),
          ),
          LessonItem(
            id: 'l9',
            title: 'Tesoura no topo (controle)',
            duration: m(15),
            isLocked: true,
          ),
        ],
      ),
      ModuleItem(
        id: 'm4',
        title: 'Módulo 4 — Máquina & acabamento',
        lessons: [
          LessonItem(
            id: 'l10',
            title: 'Acabamento com navalha',
            duration: m(13),
            isLocked: true,
          ),
          LessonItem(
            id: 'l11',
            title: 'Linha perfeita (contorno)',
            duration: m(11),
            isLocked: true,
          ),
          LessonItem(
            id: 'l12',
            title: 'Check-list de qualidade',
            duration: m(9),
            isLocked: true,
          ),
        ],
      ),
      ModuleItem(
        id: 'm5',
        title: 'Módulo 5 — Atendimento & venda',
        lessons: [
          LessonItem(
            id: 'l13',
            title: 'Postura e comunicação',
            duration: m(10),
            isLocked: true,
          ),
          LessonItem(
            id: 'l14',
            title: 'Como fidelizar cliente',
            duration: m(12),
            isLocked: true,
          ),
          LessonItem(
            id: 'l15',
            title: 'Oferta e ticket médio',
            duration: m(14),
            isLocked: true,
          ),
        ],
      ),
    ];
  }
}

/// ============================
/// UI COMPONENTS
/// ============================

class _HeaderBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onOpenModules;

  const _HeaderBar({
    required this.title,
    required this.subtitle,
    this.onOpenModules,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF54D66A), Color(0xFF2B7CFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2B7CFF).withOpacity(0.30),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          if (onOpenModules != null) ...[
            const SizedBox(width: 10),
            _SmallAction(
              icon: Icons.menu_rounded,
              label: 'Módulos',
              onTap: onOpenModules!,
            ),
          ],
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SmallAction({
    required this.icon,
    required this.label,
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
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Módulos',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayerCard extends StatelessWidget {
  final String lessonTitle;
  final String moduleTitle;

  const _VideoPlayerCard({
    required this.lessonTitle,
    required this.moduleTitle,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2B7CFF),
                          Color(0xFF54D66A),
                          Color(0xFFFF3B30),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(color: Colors.black.withOpacity(0.35)),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.20),
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 12,
                    child: Text(
                      moduleTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            lessonTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Assista e aplique. Conteúdo direto, execução real, padrão profissional.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontWeight: FontWeight.w600,
              fontSize: 12.8,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonMetaRow extends StatelessWidget {
  final Duration duration;
  final bool watched;
  final bool locked;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _LessonMetaRow({
    required this.duration,
    required this.watched,
    required this.locked,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    String two(int v) => v.toString().padLeft(2, '0');
    final mins = duration.inMinutes;
    final secs = duration.inSeconds % 60;

    return Row(
      children: [
        _MiniChip(
          icon: Icons.schedule_rounded,
          label: '${two(mins)}:${two(secs)}',
          gradient: const LinearGradient(
            colors: [Color(0xFF2B7CFF), Color(0xFF0B5FFF)],
          ),
        ),
        const SizedBox(width: 10),
        _MiniChip(
          icon: watched ? Icons.check_circle_rounded : Icons.timelapse_rounded,
          label: watched ? 'Concluída' : 'Em andamento',
          gradient: LinearGradient(
            colors: watched
                ? const [Color(0xFF54D66A), Color(0xFF1E8D33)]
                : const [Color(0xFFFFE278), Color(0xFFDB9F07)],
          ),
        ),
        const SizedBox(width: 10),
        if (locked)
          _MiniChip(
            icon: Icons.lock_rounded,
            label: 'Bloqueada',
            gradient: const LinearGradient(
              colors: [Color(0xFFFF4B4B), Color(0xFFB3001B)],
            ),
          ),
        const Spacer(),
        _NavBtn(
          text: 'Anterior',
          icon: Icons.chevron_left_rounded,
          onTap: onPrev,
        ),
        const SizedBox(width: 10),
        _NavBtn(
          text: 'Próxima',
          icon: Icons.chevron_right_rounded,
          onTap: onNext,
          iconRight: true,
        ),
      ],
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool iconRight;
  final VoidCallback? onTap;

  const _NavBtn({
    required this.text,
    required this.icon,
    required this.onTap,
    this.iconRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: GestureDetector(
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
            children: iconRight
                ? [
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(icon, color: Colors.white, size: 18),
                  ]
                : [
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
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

class _InfoGlassCard extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;
  final Gradient gradient;

  const _InfoGlassCard({
    required this.title,
    required this.text,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: gradient,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontWeight: FontWeight.w600,
              fontSize: 12.6,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextUpCard extends StatelessWidget {
  final String nextLabel;
  final VoidCallback? onTap;

  const _NextUpCard({required this.nextLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF54D66A), Color(0xFF2B7CFF)],
              ),
            ),
            child: const Icon(
              Icons.skip_next_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Próxima aula',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nextLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Opacity(
            opacity: disabled ? 0.45 : 1,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withOpacity(0.10),
                  border: Border.all(color: Colors.white.withOpacity(0.16)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Assistir',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
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

/// ============================
/// SIDEBAR: módulos + aulas
/// ============================
class _ModulesSidebar extends StatefulWidget {
  final List<ModuleItem> modules;
  final int selectedModuleIndex;
  final int selectedLessonIndex;
  final void Function(int moduleIndex, int lessonIndex) onSelect;

  const _ModulesSidebar({
    required this.modules,
    required this.selectedModuleIndex,
    required this.selectedLessonIndex,
    required this.onSelect,
  });

  @override
  State<_ModulesSidebar> createState() => _ModulesSidebarState();
}

class _ModulesSidebarState extends State<_ModulesSidebar> {
  late List<bool> expanded;

  @override
  void initState() {
    super.initState();
    expanded = List<bool>.generate(
      widget.modules.length,
      (i) => i == widget.selectedModuleIndex,
    );
  }

  @override
  void didUpdateWidget(covariant _ModulesSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedModuleIndex != widget.selectedModuleIndex) {
      expanded = List<bool>.generate(
        widget.modules.length,
        (i) => i == widget.selectedModuleIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conteúdo do curso',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.modules.length} módulos • aulas organizadas',
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              physics: kIsWeb
                  ? const ClampingScrollPhysics()
                  : const BouncingScrollPhysics(),
              itemCount: widget.modules.length,
              itemBuilder: (context, mi) {
                final m = widget.modules[mi];
                return _ModuleAccordion(
                  title: m.title,
                  indexLabel: (mi + 1).toString().padLeft(2, '0'),
                  expanded: expanded[mi],
                  onToggle: () => setState(() => expanded[mi] = !expanded[mi]),
                  lessons: m.lessons,
                  selected: mi == widget.selectedModuleIndex
                      ? widget.selectedLessonIndex
                      : null,
                  onTapLesson: (li) => widget.onSelect(mi, li),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleAccordion extends StatelessWidget {
  final String title;
  final String indexLabel;
  final bool expanded;
  final VoidCallback onToggle;
  final List<LessonItem> lessons;
  final int? selected;
  final ValueChanged<int> onTapLesson;

  const _ModuleAccordion({
    required this.title,
    required this.indexLabel,
    required this.expanded,
    required this.onToggle,
    required this.lessons,
    required this.selected,
    required this.onTapLesson,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2B7CFF), Color(0xFF54D66A)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        indexLabel,
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
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13.2,
                        height: 1.15,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0x22FFFFFF)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lessons.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0x14FFFFFF),
              ),
              itemBuilder: (context, li) {
                final l = lessons[li];
                final isSelected = selected == li;

                return InkWell(
                  onTap: l.isLocked ? null : () => onTapLesson(li),
                  child: Opacity(
                    opacity: l.isLocked ? 0.45 : 1,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      color: isSelected
                          ? Colors.white.withOpacity(0.06)
                          : Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            l.isLocked
                                ? Icons.lock_rounded
                                : (l.isWatched
                                      ? Icons.check_circle_rounded
                                      : Icons.play_circle_outline_rounded),
                            color: l.isLocked
                                ? Colors.white.withOpacity(0.70)
                                : (l.isWatched
                                      ? const Color(0xFF54D66A)
                                      : Colors.white.withOpacity(0.85)),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.88),
                                fontWeight: FontWeight.w700,
                                fontSize: 12.6,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${l.duration.inMinutes} min',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.60),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// ============================
/// CHIPS / GLASS
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
                colors: [Colors.transparent, Colors.black54],
                stops: const [0.55, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
