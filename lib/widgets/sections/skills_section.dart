import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/skill.dart';
import '../../utils/app_theme.dart';

class SkillsSection extends StatelessWidget {
  final List<Skill> skills;

  const SkillsSection({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Skills'),
          const SizedBox(height: 60),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
            ),
            itemCount: skills.length,
            itemBuilder: (context, index) =>
                _buildSkillCard(context, skills[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Builder(
      builder: (context) => AutoSizeText(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSkillCard(BuildContext context, Skill skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Skill icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSkillIcon(skill.name),
                  size: 30,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              // Skill name
              AutoSizeText(
                skill.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              // Skill level
              AutoSizeText(
                'Level ${skill.proficiency}/5',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimaryColor.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Progress bar
              LinearProgressIndicator(
                value: skill.proficiency / 5.0,
                backgroundColor: AppTheme.surfaceColor,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSkillIcon(String skillName) {
    switch (skillName.toLowerCase()) {
      case 'flutter':
      case 'dart':
        return Icons.mobile_friendly;
      case 'javascript':
      case 'typescript':
        return Icons.code;
      case 'react':
        return Icons.web;
      case 'node.js':
      case 'nodejs':
        return Icons.settings;
      case 'python':
        return Icons.code;
      case 'java':
        return Icons.code;
      case 'git':
        return Icons.code;
      case 'docker':
        return Icons.settings;
      case 'aws':
        return Icons.cloud;
      case 'firebase':
        return Icons.local_fire_department;
      case 'mongodb':
        return Icons.storage;
      case 'postgresql':
        return Icons.storage;
      case 'figma':
        return Icons.design_services;
      case 'photoshop':
        return Icons.brush;
      default:
        return Icons.star;
    }
  }
}
