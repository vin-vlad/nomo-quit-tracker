import 'dart:math';

import 'package:drift/drift.dart';

import 'app_database.dart';

/// Seeds the database with realistic dummy data for testing the Insights page.
///
/// This creates:
/// - "Smoking" tracker  (quit ~45 days ago, heavy cravings tapering down)
/// - "Alcohol" tracker  (quit ~20 days ago, moderate weekend-heavy cravings)
/// - "Caffeine" tracker (quit ~90 days ago, light cravings mostly morning)
///
/// To use:
/// 1. Delete the existing nomo.db so onCreate runs again, OR call this
///    function manually from a debug button.
/// 2. Enable premium via the debug toggle in Settings to view Insights.
Future<void> seedDevData(AppDatabase db) async {
  final now = DateTime.now();
  final random = Random(42); // fixed seed for reproducible data

  // Shared constants
  const triggers = [
    'stress',
    'boredom',
    'social',
    'habit',
    'anxiety',
    'celebration',
    'other',
  ];

  const sampleNotes = [
    'Felt a strong urge after lunch',
    'Coworker was doing it nearby',
    'Stressed about deadline',
    'Morning routine triggered it',
    'Bored at home, nothing to do',
    'Party was hard to resist',
    'Just a passing thought',
    'Woke up wanting one',
    'After a big meal',
    'Driving home from work',
    null, // quick log — no note
    null,
    null,
    null,
    null,
  ];

  var globalCravingIndex = 0;
  var globalSlipIndex = 0;

  // ════════════════════════════════════════════════════════════════════════
  // Helper: insert cravings for a tracker
  // ════════════════════════════════════════════════════════════════════════
  Future<void> insertCravings({
    required String trackerId,
    required int totalDays,
    required double maxBase,
    required double minBase,
    required List<int> hourWeights,
    required double detailProbability,
  }) async {
    // Build weighted hour list
    final weightedHours = <int>[];
    for (var h = 0; h < 24; h++) {
      for (var w = 0; w < hourWeights[h]; w++) {
        weightedHours.add(h);
      }
    }

    for (var daysAgo = totalDays; daysAgo >= 0; daysAgo--) {
      final day = now.subtract(Duration(days: daysAgo));
      final progressRatio = daysAgo / totalDays; // 1.0 = oldest, 0.0 = today
      final baseCravings =
          (minBase + (progressRatio * (maxBase - minBase))).round();
      final dailyCount = max(0, baseCravings + random.nextInt(3) - 1);

      for (var i = 0; i < dailyCount; i++) {
        final hour = weightedHours[random.nextInt(weightedHours.length)];
        final minute = random.nextInt(60);
        final timestamp =
            DateTime(day.year, day.month, day.day, hour, minute);

        final hasDetails = random.nextDouble() < detailProbability;
        final intensity = hasDetails ? (random.nextInt(8) + 2) : null;
        final trigger =
            hasDetails ? triggers[random.nextInt(triggers.length)] : null;
        final note =
            hasDetails ? sampleNotes[random.nextInt(sampleNotes.length)] : null;

        await db.into(db.cravings).insert(
              CravingsCompanion.insert(
                id: 'dev-craving-$globalCravingIndex',
                trackerId: trackerId,
                timestamp: timestamp,
                intensity: Value(intensity),
                trigger: Value(trigger),
                note: Value(note),
              ),
            );
        globalCravingIndex++;
      }
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // Helper: insert slip records for a tracker
  // ════════════════════════════════════════════════════════════════════════
  Future<void> insertSlips({
    required String trackerId,
    required List<({int daysAgo, String? note})> slips,
  }) async {
    for (final slip in slips) {
      final timestamp = now.subtract(Duration(days: slip.daysAgo));
      await db.into(db.slips).insert(
            SlipsCompanion.insert(
              id: 'dev-slip-$globalSlipIndex',
              trackerId: trackerId,
              timestamp: DateTime(
                timestamp.year,
                timestamp.month,
                timestamp.day,
                14 + random.nextInt(6),
                random.nextInt(60),
              ),
              note: Value(slip.note),
            ),
          );
      globalSlipIndex++;
    }
  }

  // ── Hour-weight presets ─────────────────────────────────────────────

  // General: peaks at 8-10 AM and 6-9 PM
  const generalHourWeights = <int>[
    1, 1, 0, 0, 0, 1, // 0-5 AM
    3, 5, 8, 8, 6, 4, // 6-11 AM
    6, 5, 4, 4, 5, 6, // 12-5 PM
    8, 9, 7, 5, 3, 2, // 6-11 PM
  ];

  // Evening-heavy: peaks at 6-11 PM (alcohol pattern)
  const eveningHourWeights = <int>[
    0, 0, 0, 0, 0, 0, // 0-5 AM
    0, 0, 1, 1, 1, 2, // 6-11 AM
    3, 3, 2, 3, 4, 5, // 12-5 PM
    8, 10, 10, 9, 7, 4, // 6-11 PM
  ];

  // Morning-heavy: peaks at 6-10 AM (caffeine pattern)
  const morningHourWeights = <int>[
    1, 0, 0, 0, 0, 2, // 0-5 AM
    5, 9, 10, 8, 5, 3, // 6-11 AM
    4, 5, 4, 3, 2, 1, // 12-5 PM
    1, 1, 0, 0, 0, 0, // 6-11 PM
  ];

  // ══════════════════════════════════════════════════════════════════════
  // 1. SMOKING — quit 45 days ago, heavy→tapering cravings
  // ══════════════════════════════════════════════════════════════════════
  const smokingId = 'dev-tracker-1';
  final smokingQuit = now.subtract(const Duration(days: 45));

  await db.into(db.trackers).insert(
        TrackersCompanion.insert(
          id: smokingId,
          name: 'Smoking',
          addictionTypeId: 'smoking',
          quitDate: smokingQuit,
          dailyCost: const Value(12.0),
          dailyFrequency: const Value(15),
          currencyCode: const Value('USD'),
          isActive: const Value(true),
          sortOrder: const Value(0),
          createdAt: smokingQuit,
          updatedAt: now,
        ),
      );

  await insertCravings(
    trackerId: smokingId,
    totalDays: 38,
    maxBase: 8,
    minBase: 2,
    hourWeights: generalHourWeights,
    detailProbability: 0.6,
  );

  await insertSlips(
    trackerId: smokingId,
    slips: [
      (daysAgo: 30, note: 'Had one at a party, reset my mindset next day'),
      (daysAgo: 18, note: 'Stressful week, slipped once'),
      (daysAgo: 7, note: null),
    ],
  );

  // ══════════════════════════════════════════════════════════════════════
  // 2. ALCOHOL — quit 20 days ago, moderate cravings, evening-heavy
  // ══════════════════════════════════════════════════════════════════════
  const alcoholId = 'dev-tracker-2';
  final alcoholQuit = now.subtract(const Duration(days: 20));

  await db.into(db.trackers).insert(
        TrackersCompanion.insert(
          id: alcoholId,
          name: 'Alcohol',
          addictionTypeId: 'alcohol',
          quitDate: alcoholQuit,
          dailyCost: const Value(18.0),
          dailyFrequency: const Value(3),
          currencyCode: const Value('USD'),
          isActive: const Value(true),
          sortOrder: const Value(1),
          createdAt: alcoholQuit,
          updatedAt: now,
        ),
      );

  await insertCravings(
    trackerId: alcoholId,
    totalDays: 18,
    maxBase: 5,
    minBase: 1,
    hourWeights: eveningHourWeights,
    detailProbability: 0.5,
  );

  await insertSlips(
    trackerId: alcoholId,
    slips: [
      (daysAgo: 12, note: 'Friday night out, had two beers'),
    ],
  );

  // ══════════════════════════════════════════════════════════════════════
  // 3. CAFFEINE — quit 90 days ago, light cravings, morning-heavy
  // ══════════════════════════════════════════════════════════════════════
  const caffeineId = 'dev-tracker-3';
  final caffeineQuit = now.subtract(const Duration(days: 90));

  await db.into(db.trackers).insert(
        TrackersCompanion.insert(
          id: caffeineId,
          name: 'Caffeine',
          addictionTypeId: 'caffeine',
          quitDate: caffeineQuit,
          dailyCost: const Value(6.0),
          dailyFrequency: const Value(4),
          currencyCode: const Value('USD'),
          isActive: const Value(true),
          sortOrder: const Value(2),
          createdAt: caffeineQuit,
          updatedAt: now,
        ),
      );

  await insertCravings(
    trackerId: caffeineId,
    totalDays: 80,
    maxBase: 4,
    minBase: 1,
    hourWeights: morningHourWeights,
    detailProbability: 0.4,
  );

  await insertSlips(
    trackerId: caffeineId,
    slips: [
      (daysAgo: 65, note: 'Had an espresso at a meeting'),
      (daysAgo: 30, note: null),
    ],
  );

  // ── Mark onboarding as completed ────────────────────────────────────
  await (db.update(db.userSettingsTable)
        ..where((s) => s.id.equals(1)))
      .write(
    const UserSettingsTableCompanion(
      hasCompletedOnboarding: Value(true),
    ),
  );
}
