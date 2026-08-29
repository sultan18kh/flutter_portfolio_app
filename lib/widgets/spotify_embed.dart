/// A Spotify playlist embed player. On Flutter Web this renders the real
/// `open.spotify.com/embed/playlist/...` iframe (no auth needed — Spotify's
/// embed player is public for public playlists). On any other platform
/// (this app only ships to web, but `flutter analyze` still compiles every
/// platform target) it falls back to a plain "open on Spotify" link, since
/// iframes don't exist outside the browser.
library;

export 'spotify_embed_stub.dart'
    if (dart.library.html) 'spotify_embed_web.dart';
