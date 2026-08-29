import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../utils/app_theme.dart';

/// Renders Spotify's real embed player in an iframe — public, no auth
/// required. Each instance gets its own registered view factory (keyed by
/// playlist + object identity) since `registerViewFactory` throws if the
/// same view type is registered twice.
class SpotifyEmbed extends StatefulWidget {
  final String playlistId;
  final double height;

  const SpotifyEmbed({
    super.key,
    required this.playlistId,
    this.height = 360,
  });

  @override
  State<SpotifyEmbed> createState() => _SpotifyEmbedState();
}

class _SpotifyEmbedState extends State<SpotifyEmbed> {
  late final String _viewType;
  // The iframe's own 'load' event is the only signal available for a
  // cross-origin embed — it doesn't guarantee Spotify's player has finished
  // painting, but it's the closest proxy without a documented postMessage
  // ready-event, and a big improvement over no feedback at all.
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _viewType = 'spotify-embed-${widget.playlistId}-$hashCode';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src =
            'https://open.spotify.com/embed/playlist/${widget.playlistId}?utm_source=generator&theme=0'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..loading = 'lazy'
        ..allow =
            'autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture';
      iframe.addEventListener(
        'load',
        (web.Event _) {
          if (mounted) setState(() => _loaded = true);
        }.toJS,
      );
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            HtmlElementView(viewType: _viewType),
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: _loaded ? 0 : 1,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  color: AppTheme.surfaceColor,
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
