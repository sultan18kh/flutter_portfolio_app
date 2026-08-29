import 'package:flutter/material.dart';

/// Stable per-section GlobalKeys, keyed by the same section id used by
/// [ModernNavbar]'s nav items. Lets scroll-to-section resolve the real
/// rendered position via [Scrollable.ensureVisible] instead of hardcoded
/// pixel offsets that drift every time section content changes.
class SectionKeys {
  static final Map<String, GlobalKey> keys = {
    'home': GlobalKey(debugLabel: 'home'),
    'about': GlobalKey(debugLabel: 'about'),
    'experience': GlobalKey(debugLabel: 'experience'),
    'skills': GlobalKey(debugLabel: 'skills'),
    'certifications': GlobalKey(debugLabel: 'certifications'),
    'projects': GlobalKey(debugLabel: 'projects'),
    'contact': GlobalKey(debugLabel: 'contact'),
  };
}
