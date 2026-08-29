import 'package:flutter/material.dart';
import '../models/skill.dart';
import 'floating_skill_icon.dart';

class SkillsGrid extends StatelessWidget {
  // Proficiency ratings (from the portfolio data) for the icons below that
  // have a matching named entry; icons with no match use the default size.
  final List<Skill> proficiencies;

  // Skill data with icon paths and names
  static const List<Map<String, String>> skills = [
    {'path': 'assets/skills/flutter.svg', 'name': 'Flutter'},
    {'path': 'assets/skills/dart.svg', 'name': 'Dart'},
    {'path': 'assets/skills/ios.svg', 'name': 'iOS'},
    {'path': 'assets/skills/android.svg', 'name': 'Android'},
    {'path': 'assets/skills/python.svg', 'name': 'Python'},
    {'path': 'assets/skills/node.svg', 'name': 'Node.js'},
    {'path': 'assets/skills/azureai.svg', 'name': 'Azure AI'},
    {'path': 'assets/skills/huggingface.svg', 'name': 'Hugging Face'},
    {'path': 'assets/skills/azure.svg', 'name': 'Azure Cloud Services'},
    {'path': 'assets/skills/firebase.svg', 'name': 'Firebase'},
    {'path': 'assets/skills/git.svg', 'name': 'Git'},
    {'path': 'assets/skills/github.svg', 'name': 'GitHub'},
    {'path': 'assets/skills/graphql.svg', 'name': 'GraphQL'},
    // {'path': 'assets/skills/vercel.svg', 'name': 'Vercel'},
  ];

  const SkillsGrid({super.key, this.proficiencies = const []});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid configuration
        final double width = constraints.maxWidth;
        final int crossAxisCount = _getCrossAxisCount(width);
        final double baseIconSize = _getIconSize(width, crossAxisCount);

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: List.generate(
            skills.length,
            (index) => FloatingSkillIcon(
              assetPath: skills[index]['path']!,
              skillName: skills[index]['name']!,
              size: baseIconSize * _proficiencyScale(skills[index]['name']!),
              floatingRange: 15.0,
              animationDuration: Duration(
                milliseconds: 2500 + (index % 3) * 500,
              ),
              delay: Duration(
                milliseconds: index * 100,
              ),
            ),
          ),
        );
      },
    );
  }

  // Scales an icon by its rated proficiency (1-5) when one is on record;
  // icons with no matching rating (e.g. iOS, GitHub) stay at base size.
  double _proficiencyScale(String skillName) {
    for (final skill in proficiencies) {
      if (skill.name.toLowerCase() == skillName.toLowerCase()) {
        return 0.8 + (skill.proficiency.clamp(1, 5) / 5) * 0.3;
      }
    }
    return 1.0;
  }

  int _getCrossAxisCount(double width) {
    if (width > 1200) return 7;
    if (width > 900) return 5;
    if (width > 600) return 4;
    return 3;
  }

  double _getIconSize(double width, int crossAxisCount) {
    final double availableWidth = width - (24 * (crossAxisCount - 1));
    final double calculatedSize = availableWidth / crossAxisCount;
    return calculatedSize.clamp(60.0, 100.0);
  }
}
