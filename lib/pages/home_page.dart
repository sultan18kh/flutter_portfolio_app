import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../blocs/portfolio_bloc.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/navigation_drawer.dart';
import '../utils/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Sultan Khan'),
      drawer: const AppNavigationDrawer(),
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state is PortfolioLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (state is PortfolioError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  AutoSizeText(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          if (state is PortfolioLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  _buildHeroSection(context, state.personalInfo),
                  const SizedBox(height: 48),

                  // Quick Stats
                  _buildQuickStats(context, state),
                  const SizedBox(height: 48),

                  // Featured Projects
                  _buildFeaturedProjects(context, state.projects),
                  const SizedBox(height: 48),

                  // Skills Overview
                  _buildSkillsOverview(context, state.skills),
                ],
              ),
            );
          }

          return const Center(
            child: AutoSizeText('No data available'),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, personalInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 80,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          AutoSizeText(
            personalInfo.name,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AutoSizeText(
              personalInfo.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          AutoSizeText(
            personalInfo.profile,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => context.go('/about'),
                icon: const Icon(Icons.person),
                label: const AutoSizeText('About Me'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => context.go('/contact'),
                icon: const Icon(Icons.contact_mail),
                label: const AutoSizeText('Contact'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, PortfolioLoaded state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Experience',
            '${state.experience.length}',
            Icons.work,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Projects',
            '${state.projects.length}',
            Icons.code,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Skills',
            '${state.skills.length}',
            Icons.psychology,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Certifications',
            '${state.certifications.length}',
            Icons.verified,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 8),
            AutoSizeText(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            AutoSizeText(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedProjects(BuildContext context, List projects) {
    final featuredProjects = projects.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Featured Projects',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ...featuredProjects.map((project) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(
                  Icons.code,
                  color: AppTheme.primaryColor,
                ),
                title: AutoSizeText(
                  project.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: AutoSizeText(
                  project.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.go('/projects'),
              ),
            )),
        Center(
          child: ElevatedButton(
            onPressed: () => context.go('/projects'),
            child: const AutoSizeText('View All Projects'),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsOverview(BuildContext context, List skills) {
    final topSkills =
        skills.where((skill) => skill.proficiency >= 4).take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Top Skills',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: topSkills
              .map((skill) => Chip(
                    label: AutoSizeText(skill.name),
                    backgroundColor:
                        AppTheme.primaryColor.withValues(alpha: 0.1),
                    labelStyle: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () => context.go('/skills'),
            child: const AutoSizeText('View All Skills'),
          ),
        ),
      ],
    );
  }
}
