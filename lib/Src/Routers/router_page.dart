import 'package:barber_curs/Src/Compnets/Navegaction/app_shell.dart';
import 'package:barber_curs/Src/Pages/Curso/course_screen.dart';
import 'package:barber_curs/Src/Pages/Online/online_scree.dart';
import 'package:barber_curs/Src/Pages/Perfil/perfil_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:barber_curs/Src/Pages/LogIn/login_screen.dart';
import 'package:barber_curs/Src/Pages/LogIn/cadastro_screen.dart';
import 'package:barber_curs/Src/Pages/Plan/plan_screen.dart';

// Shell (base com appbar + bottom nav)

// Tabs (conteúdo do meio)
import 'package:barber_curs/Src/Pages/Home/home_screen.dart';

// ✅ Crie telas simples pra outras abas (pode ser placeholder por enquanto)

class AppPaths {
  static const login = '/';
  static const cadastro = '/cadastro';
  static const plan = '/plan';

  // dentro do shell (com bottom nav)
  static const home = '/home';
  static const scan = '/scan';
  static const menu = '/menu';
  static const player = '/curso';
  static const profile = '/profile';
}

int _locationToIndex(String location) {
  if (location.startsWith(AppPaths.scan)) return 0;
  if (location.startsWith(AppPaths.menu)) return 1;
  if (location.startsWith(AppPaths.home)) return 2;
  if (location.startsWith(AppPaths.player)) return 3;
  if (location.startsWith(AppPaths.profile)) return 4;
  return 2;
}

String _indexToLocation(int index) {
  switch (index) {
    case 0:
      return AppPaths.scan;
    case 1:
      return AppPaths.menu;
    case 2:
      return AppPaths.home;
    case 3:
      return AppPaths.player;
    case 4:
      return AppPaths.profile;
    default:
      return AppPaths.home;
  }
}

final appRoutes = GoRouter(
  initialLocation: AppPaths.login,
  routes: [
    // ✅ Rotas SEM BottomNav
    GoRoute(
      path: AppPaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppPaths.plan,
      builder: (context, state) => const Planescreen(),
    ),
    GoRoute(
      path: AppPaths.cadastro,
      builder: (context, state) => const CadastroScreen(),
    ),

    // ✅ Rotas COM BottomNav (ShellRoute)
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.toString();
        final currentIndex = _locationToIndex(location);

        return AppShell(
          child: child,
          currentIndex: currentIndex,
          onTapIndex: (i) {
            final next = _indexToLocation(i);
            if (next != location) context.go(next);
          },

          // ✅ você pode trocar depois pelos valores reais do usuário logado
          planName: 'Gold',
          contractDate: DateTime.now(),

          onLogout: () {
            // exemplo: volta pro login
            context.go(AppPaths.login);
          },
        );
      },
      routes: [
        GoRoute(
          path: AppPaths.home,
          builder: (context, state) => HomeScreen(
            planName: 'Gold',
            contractDate: DateTime.now(),
            onLogout: () => context.go(AppPaths.login),
          ),
        ),

        GoRoute(
          path: AppPaths.menu,
          builder: (context, state) => Container(color: Colors.green),
        ),
        GoRoute(
          path: AppPaths.player,
          builder: (context, state) => CoursePlayerScreen(),
        ),
        GoRoute(
          path: AppPaths.profile,
          builder: (context, state) => ProfileScreen(
            userName: 'Aluno',
            email: 'aluno@email.com',
            planName: 'Gold',
            contractDate: DateTime.now(),
            onLogout: () => context.go('/'),
          ),
        ),
        GoRoute(
          path: AppPaths.scan,
          builder: (context, state) => OnlineLessonScreen(
            planName: 'Gold',
            courseName: 'Barber Pro',
            moduleName: 'Módulo 1 — Fundamentos',
            lessonTitle: 'Aula 1: Preparação e Setup',
            contractDate: DateTime.now(),
          ),
        ),
      ],
    ),
  ],
);
