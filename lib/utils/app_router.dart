import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/experience_page.dart';
import '../pages/projects_page.dart';
import '../pages/skills_page.dart';
import '../pages/contact_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/experience',
        name: 'experience',
        builder: (context, state) => const ExperiencePage(),
      ),
      GoRoute(
        path: '/projects',
        name: 'projects',
        builder: (context, state) => const ProjectsPage(),
      ),
      GoRoute(
        path: '/skills',
        name: 'skills',
        builder: (context, state) => const SkillsPage(),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactPage(),
      ),
    ],
  );
}
