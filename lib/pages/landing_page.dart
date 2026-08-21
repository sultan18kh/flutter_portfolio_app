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
import '../widgets/reveal_on_scroll.dart';
import '../utils/app_theme.dart';

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
              return SizedBox(
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
                          HeroSection(personalInfo: state.personalInfo),

                          // About Section
                          RevealOnScroll(
                            child: AboutSection(
                              personalInfo: state.personalInfo,
                              education: state.education,
                            ),
                          ),

                          // Skills Section
                          RevealOnScroll(
                            child: SkillsSection(skills: state.skills),
                          ),

                          // Experience Section
                          ExperienceSection(experience: state.experience),

                          // Certifications Section
                          CertificationsSection(
                            certifications: state.certifications,
                          ),

                          // Projects Section
                          ProjectsSection(projects: state.projects),

                          // Contact Section
                          ContactSection(
                            personalInfo: state.personalInfo,
                          ),
                        ],
                      ),
                    ),

                    // Floating Navigation Bar
                    ModernNavbar(scrollController: _scrollController),
                  ],
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
