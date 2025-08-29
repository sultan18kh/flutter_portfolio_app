import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../utils/app_theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showDrawer;

  const AppBarWidget({
    super.key,
    required this.title,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AutoSizeText(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
      backgroundColor: AppTheme.surfaceColor,
      elevation: 0,
      centerTitle: true,
      leading: showDrawer
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: AppTheme.primaryColor,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.brightness_6,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            // TODO: Implement theme switching
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
