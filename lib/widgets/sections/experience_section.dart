import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/experience.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';
import '../section_heading.dart';

class ExperienceSection extends StatefulWidget {
  final List<Experience> experience;

  const ExperienceSection({
    super.key,
    required this.experience,
  });

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  static const Map<String, String> _companyLogos = {
    'AlphaBOLD': 'assets/companies/alphabold.png',
    'We > I': 'assets/companies/we_over_i.jpeg',
    'Confiz Limited': 'assets/companies/confiz.jpeg',
    'Finz Technologies': 'assets/companies/finz.jpeg',
    'Fauji Fertilizer Company': 'assets/companies/ffc.png',
    'Netsol Technologies': 'assets/companies/netsol.png',
  };

  // Both card styles pad this much before their badge slot (Card's
  // Padding(40) / the compact row's matching left inset), then reserve
  // this much width for the badge itself — the rail sits at the center of
  // that slot so it lines up under either style.
  static const double _railInset = 40;
  static const double _railSlotWidth = 60;
  static const double _railX = _railInset + _railSlotWidth / 2 - 1;

  final GlobalKey _railKey = GlobalKey();
  ScrollController? _scrollController;
  double _progress = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = RevealScrollScope.maybeOf(context);
    if (controller != _scrollController) {
      _scrollController?.removeListener(_updateProgress);
      _scrollController = controller;
      _scrollController?.addListener(_updateProgress);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateProgress());
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_updateProgress);
    super.dispose();
  }

  // Fraction of the timeline that's scrolled past a fixed reference line
  // (75% down the viewport) — the rail fills as the visitor reads down the
  // career history instead of appearing all at once.
  void _updateProgress() {
    final box = _railKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final height = box.size.height;
    if (height <= 0) return;
    final screenHeight = MediaQuery.of(context).size.height;
    final next = ((screenHeight * 0.75 - top) / height).clamp(0.0, 1.0);
    if ((next - _progress).abs() > 0.001) {
      setState(() => _progress = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RevealOnScroll(child: SectionHeading('Experience')),
          const SizedBox(height: 60),
          Stack(
            key: _railKey,
            children: [
              // Dim background rail — the full career span, always visible.
              const Positioned(
                left: _railX,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: 2,
                  child: ColoredBox(color: Color(0x1FFF2E93)),
                ),
              ),
              // Lit portion — grows with scroll progress, a throughline
              // connecting the roles into one continuous career, not a
              // stack of disconnected cards.
              Positioned(
                left: _railX,
                top: 0,
                bottom: 0,
                child: FractionallySizedBox(
                  alignment: Alignment.topCenter,
                  heightFactor: _progress,
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.accentColor,
                          AppTheme.primaryColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.experience.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exp = entry.value;
                  // A single-bullet entry (an early-career internship)
                  // doesn't carry the same weight as a multi-bullet role —
                  // give it a compact row instead of the same full-size
                  // card, so seniority reads at a glance instead of being
                  // flattened.
                  final isCompact = exp.responsibilities.length <= 1;
                  return RevealOnScroll(
                    delay: Duration(milliseconds: index * 90),
                    child: isCompact
                        ? _buildCompactExperienceRow(context, exp)
                        : _buildExperienceCard(context, exp),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineBadge(String company, {bool compact = false}) {
    final path = _companyLogos[company];
    final size = compact ? 34.0 : 60.0;
    return Container(
      width: size,
      height: size,
      padding:
          path != null ? EdgeInsets.all(compact ? 5 : 10) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: path != null ? Colors.white : AppTheme.primaryColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primaryColor,
          width: compact ? 1.5 : 2.5,
        ),
        boxShadow: compact
            ? null
            : [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: path == null
          ? Icon(Icons.work_rounded,
              color: Colors.white, size: compact ? 16 : 26)
          : ClipOval(
              child: Image.asset(
                path,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.work_rounded,
                    color: AppTheme.primaryColor),
              ),
            ),
    );
  }

  Widget _buildCompactExperienceRow(BuildContext context, Experience exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      // Left inset matches the full card's Card+Padding(40) so the badge
      // centers line up between the two card styles — the rail behind
      // them depends on that alignment.
      padding: const EdgeInsets.fromLTRB(40, 14, 20, 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _railSlotWidth,
            height: 34,
            child: Center(
              child: _buildTimelineBadge(exp.company, compact: true),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                AutoSizeText(
                  '${exp.title} · ${exp.company}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                ),
                AutoSizeText(
                  exp.period,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimaryColor.withValues(alpha: 0.6),
                      ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(BuildContext context, Experience exp) {
    // Header (badge + title/company/period) stays a fixed-width Row so the
    // badge lines up with the rail behind it at every screen size. The
    // description drops below instead of squeezing into that same narrow
    // remaining column — on mobile, badge+gap was eating ~40% of the
    // card's width before any text started, forcing the description into
    // a column barely wide enough for a few words per line and stretching
    // the card's height far beyond what the content needs.
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline indicator — company logo instead of a number
                  _buildTimelineBadge(exp.company),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          exp.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        AutoSizeText(
                          exp.company,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.textPrimaryColor,
                                  ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 8),
                        AutoSizeText(
                          exp.period,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textPrimaryColor
                                        .withValues(alpha: 0.7),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AutoSizeText(
                exp.responsibilities.join('\n• '),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimaryColor.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
