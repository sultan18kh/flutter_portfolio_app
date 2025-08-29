import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../blocs/portfolio_bloc.dart';
import '../widgets/animated_background.dart';
import '../widgets/modern_navbar.dart';
import '../utils/app_theme.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: BlocBuilder<PortfolioBloc, PortfolioState>(
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
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            }

            if (state is PortfolioLoaded) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Navigation Bar
                    ModernNavbar(scrollController: _scrollController),

                    // Hero Section
                    _buildHeroSection(context, state.personalInfo),

                    // About Section
                    _buildAboutSection(
                        context, state.personalInfo, state.education),

                    // Experience Section
                    _buildExperienceSection(context, state.experience),

                    // Projects Section
                    _buildProjectsSection(context, state.projects),

                    // Skills Section
                    _buildSkillsSection(context, state.skills),

                    // Contact Section
                    _buildContactSection(
                        context, state.personalInfo, state.certifications),
                  ],
                ),
              );
            }

            return const Center(
              child: AutoSizeText(
                'No data available',
                maxLines: 1,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, personalInfo) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated gradient text
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ).createShader(bounds),
                  child: AutoSizeText(
                    personalInfo.name,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 24,
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: AutoSizeText(
                    personalInfo.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    minFontSize: 16,
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: 600,
                  child: AutoSizeText(
                    personalInfo.profile,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondaryColor,
                          height: 1.6,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    minFontSize: 14,
                  ),
                ),

                const SizedBox(height: 48),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAnimatedButton(
                      'Download CV',
                      Icons.download,
                      () => _launchUrl('mailto:${personalInfo.email}'),
                    ),
                    const SizedBox(width: 24),
                    _buildAnimatedButton(
                      'Get In Touch',
                      Icons.arrow_forward,
                      () => _scrollToSection('contact'),
                      isOutlined: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(String text, IconData icon, VoidCallback onTap,
      {bool isOutlined = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.transparent : AppTheme.primaryColor,
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isOutlined
                ? null
                : [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isOutlined ? AppTheme.primaryColor : Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              AutoSizeText(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isOutlined ? AppTheme.primaryColor : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                minFontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection(
      BuildContext context, personalInfo, List education) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          _buildSectionTitle('About Me'),
          const SizedBox(height: 60),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Info
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.secondaryColor
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    personalInfo.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    maxLines: 1,
                                    minFontSize: 16,
                                  ),
                                  AutoSizeText(
                                    personalInfo.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppTheme.primaryColor,
                                        ),
                                    maxLines: 1,
                                    minFontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        AutoSizeText(
                          personalInfo.profile,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    height: 1.6,
                                  ),
                          maxLines: 6,
                          minFontSize: 12,
                        ),
                        const SizedBox(height: 32),
                        _buildContactGrid(personalInfo),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 40),

              // Education
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Education',
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 1,
                          minFontSize: 16,
                        ),
                        const SizedBox(height: 24),
                        ...education
                            .map((edu) => _buildEducationItem(context, edu)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactGrid(personalInfo) {
    return Column(
      children: [
        _buildContactItem(Icons.email, 'Email', personalInfo.email,
            () => _launchUrl('mailto:${personalInfo.email}')),
        _buildContactItem(
            Icons.location_on, 'Location', personalInfo.home, null),
        _buildContactItem(Icons.link, 'LinkedIn', personalInfo.linkedin,
            () => _launchUrl('https://${personalInfo.linkedin}')),
        _buildContactItem(Icons.code, 'GitHub', personalInfo.github,
            () => _launchUrl(personalInfo.github)),
      ],
    );
  }

  Widget _buildContactItem(
      IconData icon, String label, String value, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMutedColor,
                      ),
                  maxLines: 1,
                  minFontSize: 10,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: AutoSizeText(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onTap != null
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondaryColor,
                          decoration:
                              onTap != null ? TextDecoration.underline : null,
                        ),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(BuildContext context, edu) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            edu.institution,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            minFontSize: 14,
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            '${edu.degree} in ${edu.field}',
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            minFontSize: 12,
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            '${edu.period} • ${edu.score}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMutedColor,
                ),
            maxLines: 1,
            minFontSize: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection(BuildContext context, List experience) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          _buildSectionTitle('Experience'),
          const SizedBox(height: 60),
          ...experience.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return _buildExperienceCard(context, exp, index);
          }),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(BuildContext context, exp, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: AutoSizeText(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    minFontSize: 16,
                  ),
                ),
              ),

              const SizedBox(width: 32),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                exp.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                maxLines: 1,
                                minFontSize: 16,
                              ),
                              AutoSizeText(
                                exp.company,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                minFontSize: 14,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: AutoSizeText(
                            exp.period,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                            maxLines: 1,
                            minFontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ...exp.responsibilities.map((responsibility) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin:
                                    const EdgeInsets.only(top: 8, right: 16),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  responsibility,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        height: 1.5,
                                      ),
                                  maxLines: 3,
                                  minFontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context, List projects) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          _buildSectionTitle('Projects'),
          const SizedBox(height: 60),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              childAspectRatio: 0.8,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) =>
                _buildProjectCard(context, projects[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, project) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project header
          Container(
            width: double.infinity,
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.code,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),

          // Project content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    project.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                    maxLines: 1,
                    minFontSize: 16,
                  ),
                  const SizedBox(height: 12),
                  AutoSizeText(
                    project.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    minFontSize: 12,
                  ),
                  const SizedBox(height: 16),

                  // Technologies
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies
                        .take(3)
                        .map((tech) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: AutoSizeText(
                                tech,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 1,
                                minFontSize: 10,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context, List skills) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          _buildSectionTitle('Skills'),
          const SizedBox(height: 60),
          ...skills.map((skill) => _buildSkillCard(context, skill)),
        ],
      ),
    );
  }

  Widget _buildSkillCard(BuildContext context, skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
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
                      maxLines: 1,
                      minFontSize: 16,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getProficiencyColor(skill.proficiency)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AutoSizeText(
                      '${skill.proficiency}/5',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getProficiencyColor(skill.proficiency),
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      minFontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress bar
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: skill.proficiency / 5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AutoSizeText(
                _getProficiencyText(skill.proficiency),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMutedColor,
                    ),
                maxLines: 1,
                minFontSize: 10,
              ),
            ],
          ),
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

  Widget _buildContactSection(
      BuildContext context, personalInfo, List certifications) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          _buildSectionTitle('Get In Touch'),
          const SizedBox(height: 60),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Form
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Send Message',
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 1,
                          minFontSize: 16,
                        ),
                        const SizedBox(height: 32),
                        _buildContactForm(),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 40),

              // Certifications
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Certifications',
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 1,
                          minFontSize: 16,
                        ),
                        const SizedBox(height: 24),
                        ...certifications.map(
                            (cert) => _buildCertificationItem(context, cert)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Message',
            prefixIcon: Icon(Icons.message),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send),
            label: const AutoSizeText(
              'Send Message',
              maxLines: 1,
              minFontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationItem(BuildContext context, cert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            cert.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
            maxLines: 1,
            minFontSize: 14,
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            cert.description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            minFontSize: 12,
          ),
          if (cert.issuer != null) ...[
            const SizedBox(height: 4),
            AutoSizeText(
              cert.issuer!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMutedColor,
                  ),
              maxLines: 1,
              minFontSize: 10,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        AutoSizeText(
          title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
          maxLines: 1,
          minFontSize: 24,
        ),
        const SizedBox(height: 16),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  void _scrollToSection(String sectionId) {
    final sections = {
      'home': 0.0,
      'about': 800.0,
      'experience': 1600.0,
      'projects': 2400.0,
      'skills': 3200.0,
      'contact': 4000.0,
    };

    final offset = sections[sectionId] ?? 0.0;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
