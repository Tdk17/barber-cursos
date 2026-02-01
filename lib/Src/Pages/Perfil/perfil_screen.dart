import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// ============================
/// PLAN UI (UTIL) ✅
/// ============================
class PlanUi {
  static String formatDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

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

/// ============================
/// PROFILE SCREEN (Premium)
/// ============================
class ProfileScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String planName;
  final DateTime contractDate;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.email,
    required this.planName,
    required this.contractDate,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notifyEnabled = true;
  bool studyMode = true;
  bool downloadsWifiOnly = true;

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
                      title: 'Perfil',
                      subtitle: 'Configurações e progresso do aluno',
                      right: _MiniChip(
                        icon: Icons.workspace_premium_rounded,
                        label: widget.planName,
                        gradient: PlanUi.gradient(widget.planName),
                      ),
                      left: IconButton(
                        onPressed: widget.onLogout,
                        tooltip: 'Sair',
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: _ProfileHeaderCard(
                      name: widget.userName,
                      email: widget.email,
                      planName: widget.planName,
                      contractDate: widget.contractDate,
                      onEdit: () {},
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: const [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.play_circle_fill_rounded,
                            title: 'Aulas',
                            value: '12',
                            gradient: LinearGradient(
                              colors: [Color(0xFF2B7CFF), Color(0xFF0B5FFF)],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.view_module_rounded,
                            title: 'Módulos',
                            value: '5',
                            gradient: LinearGradient(
                              colors: [Color(0xFF54D66A), Color(0xFF1E8D33)],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.local_fire_department_rounded,
                            title: 'Sequência',
                            value: '6d',
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFE278), Color(0xFFDB9F07)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 0),
                  sliver: SliverToBoxAdapter(
                    child: const _ProgressCard(
                      title: 'Progresso geral',
                      subtitle: '42% concluído • 12 aulas assistidas',
                      progress: 0.42,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 10),
                  sliver: SliverToBoxAdapter(
                    child: const _SectionHeader(
                      title: 'Preferências',
                      subtitle: 'Ajuste sua experiência',
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: _GlassCard(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Column(
                        children: [
                          _SwitchRow(
                            icon: Icons.notifications_active_rounded,
                            title: 'Notificações',
                            subtitle: 'Avisos de aulas e novidades',
                            value: notifyEnabled,
                            onChanged: (v) => setState(() => notifyEnabled = v),
                          ),
                          const _Divider(),
                          _SwitchRow(
                            icon: Icons.nightlight_round,
                            title: 'Modo estudo',
                            subtitle: 'Menos distrações e foco total',
                            value: studyMode,
                            onChanged: (v) => setState(() => studyMode = v),
                          ),
                          const _Divider(),
                          _SwitchRow(
                            icon: Icons.wifi_rounded,
                            title: 'Downloads só no Wi-Fi',
                            subtitle: 'Economiza dados móveis',
                            value: downloadsWifiOnly,
                            onChanged: (v) =>
                                setState(() => downloadsWifiOnly = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 18, hPad, 10),
                  sliver: SliverToBoxAdapter(
                    child: const _SectionHeader(
                      title: 'Conta',
                      subtitle: 'Ações rápidas',
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _ActionTile(
                          icon: Icons.person_rounded,
                          title: 'Editar perfil',
                          subtitle: 'Nome, foto, dados básicos',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2B7CFF), Color(0xFF54D66A)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        _ActionTile(
                          icon: Icons.support_agent_rounded,
                          title: 'Suporte',
                          subtitle: 'Fale com a equipe',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFE278), Color(0xFFDB9F07)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        _ActionTile(
                          icon: Icons.verified_user_rounded,
                          title: 'Termos e privacidade',
                          subtitle: 'Políticas da plataforma',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C4DFF), Color(0xFF2B7CFF)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        _ActionTile(
                          icon: Icons.logout_rounded,
                          title: 'Sair',
                          subtitle: 'Encerrar sessão',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF4B4B), Color(0xFFB3001B)],
                          ),
                          onTap: widget.onLogout,
                        ),
                        const SizedBox(height: 110),
                      ],
                    ),
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

/// ============================
/// TOP BAR
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

/// ============================
/// PROFILE HEADER
/// ============================
class _ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String planName;
  final DateTime contractDate;
  final VoidCallback onEdit;

  const _ProfileHeaderCard({
    required this.name,
    required this.email,
    required this.planName,
    required this.contractDate,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final contract = PlanUi.formatDate(contractDate);

    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF2B7CFF), Color(0xFF54D66A)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2B7CFF).withOpacity(0.30),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name.trim()[0].toUpperCase() : 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.6,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _MiniChip(
                      icon: Icons.event_available_rounded,
                      label: contract,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2B7CFF), Color(0xFF0B5FFF)],
                      ),
                    ),
                    _MiniChip(
                      icon: Icons.workspace_premium_rounded,
                      label: planName,
                      gradient: PlanUi.gradient(planName), // ✅ FIX
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white.withOpacity(0.06),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Editar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================
/// PROGRESS CARD
/// ============================
class _ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const _ProgressCard({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final p = progress.clamp(0.0, 1.0);

    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14.2,
            ),
          ),
          const SizedBox(height: 8),
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
                widthFactor: p,
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
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontWeight: FontWeight.w600,
              fontSize: 12.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================
/// STAT CARD
/// ============================
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: gradient,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontWeight: FontWeight.w700,
                    fontSize: 12.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
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

/// ============================
/// ACTION TILE
/// ============================
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _GlassCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: gradient,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.70),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.70),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================
/// SWITCH ROW
/// ============================
class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.66),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.2,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF54D66A),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(height: 1, color: Colors.white.withOpacity(0.10)),
    );
  }
}

/// ============================
/// SECTION HEADER
/// ============================
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
/// MINI CHIP
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
