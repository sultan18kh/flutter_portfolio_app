import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/portfolio_cubit.dart';
import '../widgets/animated_background.dart';
import '../widgets/modern_navbar.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/experience_section.dart';
import '../widgets/sections/certifications_section.dart';
import '../widgets/sections/projects_section.dart';
import '../widgets/sections/skills_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/sections/socials_section.dart';
import '../widgets/reveal_on_scroll.dart';
import '../utils/app_theme.dart';
import '../utils/section_keys.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Load portfolio data after the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PortfolioCubit>().loadPortfolio();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: BlocBuilder<PortfolioCubit, PortfolioState>(
          builder: (context, state) {
            // Safety check to prevent rendering when widget is disposed
            if (!mounted) {
              return const SizedBox.shrink();
            }
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
                    Text(
                      'Error: ${state.message}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            if (state is PortfolioLoaded) {
              return RevealScrollScope(
                controller: _scrollController,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Main content
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            // Add top padding to account for floating navbar
                            const SizedBox(height: 100),

                            // Hero Section
                            HeroSection(
                              key: SectionKeys.keys['home'],
                              personalInfo: state.personalInfo,
                            ),

                            // About Section
                            RevealOnScroll(
                              child: AboutSection(
                                key: SectionKeys.keys['about'],
                                personalInfo: state.personalInfo,
                                education: state.education,
                              ),
                            ),

                            // Skills Section
                            RevealOnScroll(
                              child: SkillsSection(
                                key: SectionKeys.keys['skills'],
                                skills: state.skills,
                              ),
                            ),

                            // Experience Section
                            ExperienceSection(
                              key: SectionKeys.keys['experience'],
                              experience: state.experience,
                            ),

                            // Certifications Section
                            CertificationsSection(
                              certifications: state.certifications,
                            ),

                            // Projects Section
                            ProjectsSection(
                              key: SectionKeys.keys['projects'],
                              projects: state.projects,
                            ),

                            // Contact Section
                            ContactSection(
                              key: SectionKeys.keys['contact'],
                              personalInfo: state.personalInfo,
                            ),

                            // Socials Section
                            const SocialsSection(),

                            // Reserve space so content never sits behind
                            // the floating bottom navbar at max scroll.
                            const SizedBox(height: 160),
                          ],
                        ),
                      ),

                      // Floating Navigation Bar
                      ModernNavbar(scrollController: _scrollController),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: Text('No data available'),
            );
          },
        ),
      ),
    );
  }
}
