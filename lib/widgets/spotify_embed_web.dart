import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

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
        child: HtmlElementView(viewType: _viewType),
      ),
    );
  }
}
