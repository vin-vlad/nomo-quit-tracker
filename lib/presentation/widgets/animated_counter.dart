import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/nomo_typography.dart';
import '../../core/theme/nomo_dimensions.dart';
import '../../core/extensions/duration_extensions.dart';

/// A rolling digit counter that shows DD:HH:MM:SS since a quit date.
/// Each digit column animates independently with a slide transition.
class AnimatedCounter extends StatefulWidget {
  final DateTime quitDate;
  final TextStyle? digitStyle;
  final TextStyle? labelStyle;
  final bool compact;

  const AnimatedCounter({
    super.key,
    required this.quitDate,
    this.digitStyle,
    this.labelStyle,
    this.compact = false,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  late Timer _timer;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.quitDate);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.quitDate);
      });
    });
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quitDate != widget.quitDate) {
      _elapsed = DateTime.now().difference(widget.quitDate);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = _elapsed.counterParts;

    final dStyle = widget.digitStyle ??
        (widget.compact ? NomoTypography.monoSmall : NomoTypography.mono)
            .copyWith(color: theme.colorScheme.onSurface);
    final lStyle = widget.labelStyle ??
        NomoTypography.caption.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _CounterSegment(value: parts.days, label: 'Days', digitStyle: dStyle, labelStyle: lStyle),
        _Separator(style: dStyle),
        _CounterSegment(value: parts.hours, label: 'Hrs', digitStyle: dStyle, labelStyle: lStyle),
        _Separator(style: dStyle),
        _CounterSegment(value: parts.minutes, label: 'Min', digitStyle: dStyle, labelStyle: lStyle),
        _Separator(style: dStyle),
        _CounterSegment(value: parts.seconds, label: 'Sec', digitStyle: dStyle, labelStyle: lStyle),
      ],
    );
  }
}

class _CounterSegment extends StatelessWidget {
  final String value;
  final String label;
  final TextStyle digitStyle;
  final TextStyle labelStyle;

  const _CounterSegment({
    required this.value,
    required this.label,
    required this.digitStyle,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Text(
            value,
            key: ValueKey(value),
            style: digitStyle,
          ),
        ),
        const SizedBox(height: NomoDimensions.spacing4),
        Text(label, style: labelStyle),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  final TextStyle style;

  const _Separator({required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NomoDimensions.spacing4,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(':', style: style),
      ),
    );
  }
}
