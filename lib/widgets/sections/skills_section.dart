import 'package:flutter/material.dart';
import '../../models/skill.dart';
import '../section_heading.dart';
import '../skills_grid.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SectionHeading('Skills'),
          const SizedBox(height: 60),
          SkillsGrid(proficiencies: skills),
        ],
      ),
    );
  }
}
