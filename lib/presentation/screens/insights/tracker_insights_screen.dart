import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/bauhaus_app_bar.dart';
import 'insights_screen.dart';

/// Displays insights for a single tracker. Reuses [InsightsContent]
/// from the main insights module.
class TrackerInsightsScreen extends ConsumerWidget {
  final String trackerId;

  const TrackerInsightsScreen({super.key, required this.trackerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const BauhausAppBar(title: 'Insights'),
      body: InsightsContent(trackerId: trackerId),
    );
  }
}
