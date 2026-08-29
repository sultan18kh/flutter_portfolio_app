import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_theme.dart';
import 'spotify_embed.dart';

// Shared by both cards so their backgrounds always match — a fixed height
// is simpler and more robust here than IntrinsicHeight, which silently
// breaks on any AutoSizeText descendant (AutoSizeText measures itself with
// an internal LayoutBuilder, and LayoutBuilder can't report intrinsic
// dimensions).
const double _kNowCardHeight = 228;

/// Shared card chrome for the "Listening to" / "Reading right now" pair —
/// same bordered-surface treatment as the About bio and Education cards.
class _NowCard extends StatelessWidget {
  final Widget child;

  const _NowCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kNowCardHeight,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );
  }
}

Widget _label(BuildContext context, IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 14, color: AppTheme.primaryColor.withValues(alpha: 0.7)),
      const SizedBox(width: 6),
      // Expanded, not a bare child — a plain Row doesn't shrink an
      // AutoSizeText that doesn't fit, it overflows past the card edge at
      // narrow widths. Expanded gives it a real width to shrink within.
      Expanded(
        child: AutoSizeText(
          text,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
        ),
      ),
    ],
  );
}

/// A live Spotify playlist embed showing top-listened tracks — the real
/// Spotify player widget, publicly embeddable with no auth needed (Spotify
/// has no auth-free "top tracks" API, so a playlist embed of your actual
/// top tracks — e.g. Spotify's own auto-generated "On Repeat" playlist, or
/// one you maintain — is the honest way to show this live, without a
/// backend). The Spotify logo signals it's a real, connected embed rather
/// than a static claim.
class SpotifyTopTracksCard extends StatelessWidget {
  const SpotifyTopTracksCard({super.key});

  // Replace with your own Top Tracks / On Repeat playlist ID (Spotify app
  // → playlist → Share → Copy link, the ID is the last path segment).
  static const String _playlistId = '3R8rXgS463C3WLok9VP0Tq';

  @override
  Widget build(BuildContext context) {
    return _NowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/socials/spotify.svg',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: AutoSizeText(
                  'MY TOP TRACKS · VIA SPOTIFY',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 152px is Spotify's own documented "compact" embed height — below
          // it the player drops the full tracklist and shows just the
          // featured track + controls, which is what fits this slot.
          const SpotifyEmbed(playlistId: _playlistId, height: 152),
        ],
      ),
    );
  }
}

/// One book per calendar month, picked by the current month — no redeploy
/// needed for it to change on the 1st. Fetched live from Open Library
/// (openlibrary.org), keyed by Work ID (e.g. "OL20709638W", found in a
/// book's Open Library URL). Empty slots below just don't render — never a
/// fabricated placeholder title.
class ReadingRightNowCard extends StatefulWidget {
  const ReadingRightNowCard({super.key});

  // Fill in a Work ID per month (index 0 = January). Leave '' for months
  // without a pick.
  static const List<String> _workIds = [
    'OL20709638W', // January
    'OL17920482W', // February
    'OL2784125W', // March
    'OL45690005W', // April
    'OL19542450W', // May
    'OL5727686W', // June
    'OL22591606W', // July
    'OL34947990W', // August
    'OL28130183W', // September
    'OL1875454W', // October
    'OL17930368W', // November
    'OL15992072W', // December
  ];

  @override
  State<ReadingRightNowCard> createState() => _ReadingRightNowCardState();
}

class _ReadingRightNowCardState extends State<ReadingRightNowCard> {
  String? _title;
  String? _author;
  String? _description;
  int? _coverId;
  bool _loading = true;
  late final String _workId;

  @override
  void initState() {
    super.initState();
    _workId = ReadingRightNowCard._workIds[DateTime.now().month - 1];
    if (_workId.isEmpty) {
      _loading = false;
    } else {
      _fetch(_workId);
    }
  }

  Future<void> _fetch(String workId) async {
    try {
      final response = await http
          .get(Uri.parse('https://openlibrary.org/works/$workId.json'))
          .timeout(const Duration(seconds: 6));
      if (response.statusCode != 200) throw Exception('bad status');
      final work = jsonDecode(response.body) as Map<String, dynamic>;

      final title = work['title'] as String?;
      // Open Library covers/works with multiple entries — always the
      // first, per API convention (it's the edition Open Library considers
      // primary).
      final covers = work['covers'] as List<dynamic>?;
      final coverId =
          (covers != null && covers.isNotEmpty) ? covers.first as int : null;

      // description is either a plain string or {type, value} — both shapes
      // appear across different works. Falls back to subtitle, and many
      // works have neither, so this must never throw — a shape surprise
      // here shouldn't cost the title/cover/author already parsed above.
      final rawDescription = work['description'];
      String? description;
      if (rawDescription is String) {
        description = rawDescription;
      } else if (rawDescription is Map && rawDescription['value'] is String) {
        description = rawDescription['value'] as String;
      }
      description ??=
          work['subtitle'] is String ? work['subtitle'] as String : null;

      // Author name needs a second call — the work only carries a
      // reference key, and only the first author (by Open Library's own
      // list order) is used even when a work has several. Best-effort: a
      // failure here just omits the byline.
      String? author;
      final authors = work['authors'] as List<dynamic>?;
      if (authors != null && authors.isNotEmpty) {
        final authorKey =
            (authors.first as Map<String, dynamic>)['author']['key'] as String?;
        if (authorKey != null) {
          try {
            final authorResponse = await http
                .get(Uri.parse('https://openlibrary.org$authorKey.json'))
                .timeout(const Duration(seconds: 6));
            if (authorResponse.statusCode == 200) {
              author = (jsonDecode(authorResponse.body)
                  as Map<String, dynamic>)['name'] as String?;
            }
          } catch (_) {
            // No byline — the title alone still stands.
          }
        }
      }

      if (mounted) {
        setState(() {
          _title = title;
          _author = author;
          _description = description;
          _coverId = coverId;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Human book page, not the .json API endpoint — tappable once a title
    // has actually loaded, so a failed fetch or an unset month never opens
    // a dead-end link.
    final body = _buildBody(context);
    return _NowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(context, Icons.menu_book_rounded, 'READING RIGHT NOW'),
          const SizedBox(height: 12),
          _title == null
              ? body
              : InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('https://openlibrary.org/works/$_workId'),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: body,
                ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.primaryColor,
          ),
        ),
      );
    }

    final title = _title;
    if (title == null) {
      return Center(
        child: AutoSizeText(
          'No pick set for this month',
          maxLines: 1,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textPrimaryColor.withValues(alpha: 0.5),
              ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: _coverId == null
              ? Container(
                  width: 90,
                  height: 130,
                  color: AppTheme.backgroundColor,
                  child: const Icon(Icons.menu_book_rounded,
                      color: AppTheme.primaryColor, size: 28),
                )
              : Image.network(
                  'https://covers.openlibrary.org/b/id/$_coverId-L.jpg',
                  width: 90,
                  height: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 90,
                    height: 130,
                    color: AppTheme.backgroundColor,
                    child: const Icon(Icons.menu_book_rounded,
                        color: AppTheme.primaryColor, size: 28),
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                title,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_author != null) ...[
                const SizedBox(height: 4),
                AutoSizeText(
                  _author!,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimaryColor.withValues(alpha: 0.6),
                      ),
                ),
              ],
              if (_description != null) ...[
                const SizedBox(height: 6),
                // Plain Text + ellipsis, not AutoSizeText — a paragraph
                // should truncate at a fixed size, not shrink to fit,
                // and the card's height is fixed so it can't grow with it.
                Text(
                  _description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimaryColor.withValues(alpha: 0.5),
                        height: 1.3,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
