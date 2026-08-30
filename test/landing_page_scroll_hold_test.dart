import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_flutter/pages/landing_page.dart';

void main() {
  final base = DateTime(2026, 1, 1, 12, 0, 0);
  const settle = Duration(milliseconds: 120);

  test('debounces to settle while well inside the deadline', () {
    final deadline = base.add(const Duration(milliseconds: 900));
    final delay = scrollHoldReleaseDelay(deadline: deadline, settle: settle, now: base);
    expect(delay, settle);
  });

  test('shrinks to whatever remains once inside the settle window', () {
    final deadline = base.add(const Duration(milliseconds: 50));
    final delay = scrollHoldReleaseDelay(deadline: deadline, settle: settle, now: base);
    expect(delay, const Duration(milliseconds: 50));
  });

  test('releases immediately once the deadline has passed', () {
    final deadline = base.add(const Duration(milliseconds: -10));
    final delay = scrollHoldReleaseDelay(deadline: deadline, settle: settle, now: base);
    expect(delay, Duration.zero);
  });

  test('a fresh event each 80ms keeps pushing release out, capped by the deadline', () {
    final deadline = base.add(const Duration(milliseconds: 900));
    var now = base;
    var releasedAtOrBeforeDeadline = false;
    // Simulate a momentum tail: an event arrives every 80ms, faster than
    // settle (120ms), so the hold should never let go early — release only
    // ever gets clamped tighter as `now` approaches the deadline, and fires
    // (delay of zero) once `now` reaches it.
    for (var i = 0; i < 20; i++) {
      now = now.add(const Duration(milliseconds: 80));
      final delay = scrollHoldReleaseDelay(deadline: deadline, settle: settle, now: now);
      if (now.isBefore(deadline) || now.isAtSameMomentAs(deadline)) {
        expect(now.add(delay).isAfter(deadline), isFalse);
      }
      if (delay == Duration.zero && !now.isBefore(deadline)) {
        releasedAtOrBeforeDeadline = true;
      }
    }
    expect(releasedAtOrBeforeDeadline, isTrue);
  });
}
