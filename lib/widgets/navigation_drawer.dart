import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../utils/app_theme.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppTheme.surfaceColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AutoSizeText(
                    'Sultan Khan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  AutoSizeText(
                    'Senior Solution Developer',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'Home',
              route: '/',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.person,
              title: 'About',
              route: '/about',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.work,
              title: 'Experience',
              route: '/experience',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.code,
              title: 'Projects',
              route: '/projects',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.psychology,
              title: 'Skills',
              route: '/skills',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.contact_mail,
              title: 'Contact',
              route: '/contact',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryColor,
      ),
      title: AutoSizeText(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      onTap: () {
        context.go(route);
        Navigator.pop(context);
      },
    );
  }
}
