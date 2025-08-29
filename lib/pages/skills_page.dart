import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../blocs/portfolio_bloc.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/navigation_drawer.dart';
import '../utils/app_theme.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Skills'),
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
                  AutoSizeText(
                    'Skills & Expertise',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  AutoSizeText(
                    'My technical skills and proficiency levels',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: 32),
                  _buildSkillsList(context, state.skills),
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

  Widget _buildSkillsList(BuildContext context, List skills) {
    // Sort skills by proficiency level (highest first)
    final sortedSkills = List.from(skills)
      ..sort((a, b) => b.proficiency.compareTo(a.proficiency));

    return Column(
      children:
          sortedSkills.map((skill) => _buildSkillCard(context, skill)).toList(),
    );
  }

  Widget _buildSkillCard(BuildContext context, skill) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    skill.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getProficiencyColor(skill.proficiency)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AutoSizeText(
                    '${skill.proficiency}/5',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getProficiencyColor(skill.proficiency),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Proficiency bars
            Row(
              children: List.generate(5, (index) {
                final isFilled = index < skill.proficiency;
                return Expanded(
                  child: Container(
                    height: 8,
                    margin: EdgeInsets.only(
                      right: index < 4 ? 4 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: isFilled
                          ? _getProficiencyColor(skill.proficiency)
                          : AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),

            // Proficiency level text
            AutoSizeText(
              _getProficiencyText(skill.proficiency),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProficiencyColor(int proficiency) {
    switch (proficiency) {
      case 5:
        return Colors.green;
      case 4:
        return AppTheme.primaryColor;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.red;
      case 1:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getProficiencyText(int proficiency) {
    switch (proficiency) {
      case 5:
        return 'Expert';
      case 4:
        return 'Advanced';
      case 3:
        return 'Intermediate';
      case 2:
        return 'Beginner';
      case 1:
        return 'Basic';
      default:
        return 'Basic';
    }
  }
}
