import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../blocs/navbar_bloc/navbar_cubit.dart';
import 'morph_keys.dart';
import 'section_keys.dart';

/// Drives the Hero→About profile-photo morph as a single 0..1 value.
///
/// Recomputed from live render-box positions on every scroll tick instead
/// of hardcoded pixel geometry, so the morph stays correct across
/// breakpoints (the About portrait sits in a Row on wide screens, a
/// Column on narrow ones) without tracking layout changes by hand.
class PhotoMorphProgress extends ChangeNotifier {
  double t = 0;

  void recompute(ScrollController controller) {
    try {
      if (!controller.hasClients) return;

      final heroBox = MorphKeys.heroPhoto.currentContext?.findRenderObject();
      final aboutBox = MorphKeys.aboutPhoto.currentContext?.findRenderObject();
      final homeObj =
          SectionKeys.keys['home']?.currentContext?.findRenderObject();
      final aboutSectionObj =
          SectionKeys.keys['about']?.currentContext?.findRenderObject();
      if (heroBox is! RenderBox ||
          !heroBox.attached ||
          aboutBox is! RenderBox ||
          !aboutBox.attached ||
          homeObj == null ||
          aboutSectionObj == null) {
        return;
      }

      final homeOffset = RenderAbstractViewport.of(homeObj)
          .getOffsetToReveal(homeObj, 0.0)
          .offset;
      final aboutOffset = RenderAbstractViewport.of(aboutSectionObj)
          .getOffsetToReveal(aboutSectionObj, 0.0)
          .offset;

      // Start once the hero photo is mostly scrolled past; land exactly
      // where nav's own scroll-to-about already settles (shared formula —
      // must match or t never reaches 1, stranding the overlay/real photo
      // mid-crossfade).
      final start = homeOffset + heroBox.size.height * 1.6;
      final end = NavbarCubit.restingOffsetFor('about', aboutOffset);
      final next = end > start
          ? ((controller.offset - start) / (end - start)).clamp(0.0, 1.0)
          : 0.0;

      if (next != t) {
        t = next;
        notifyListeners();
      }
    } catch (e, st) {
      debugPrint('[DBG] PhotoMorphProgress.recompute threw: $e\n$st');
    }
  }
}
