import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_theme.dart';

/// Non-web fallback — iframes only exist in a browser, so anywhere else
/// this just links out to the playlist instead.
class SpotifyEmbed extends StatelessWidget {
  final String playlistId;
  final double height;

  const SpotifyEmbed({
    super.key,
    required this.playlistId,
    this.height = 360,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () => launchUrl(
          Uri.parse('https://open.spotify.com/playlist/$playlistId'),
        ),
        child: const Text('Open playlist on Spotify'),
      ),
    );
  }
}
