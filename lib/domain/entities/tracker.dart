import 'addiction_type.dart';
import 'slip_record.dart';

/// A quit tracker — the core entity of the app.
class Tracker {
  final String id;
  final String name;
  final AddictionType type;
  final String? customTypeName;
  final DateTime quitDate;
  final double? dailyCost;
  final int? dailyFrequency;
  final String currencyCode;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SlipRecord> slips;

  const Tracker({
    required this.id,
    required this.name,
    required this.type,
    this.customTypeName,
    required this.quitDate,
    this.dailyCost,
    this.dailyFrequency,
    required this.currencyCode,
    this.isActive = true,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    this.slips = const [],
  });

  /// Duration since quit date.
  Duration get elapsed => DateTime.now().difference(quitDate);

  /// Total money saved based on daily cost.
  double get totalSaved {
    if (dailyCost == null) return 0;
    final days = elapsed.inSeconds / 86400; // fractional days
    return days * dailyCost!;
  }

  /// Create a copy with modified fields.
  Tracker copyWith({
    String? id,
    String? name,
    AddictionType? type,
    String? customTypeName,
    DateTime? quitDate,
    double? dailyCost,
    int? dailyFrequency,
    String? currencyCode,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<SlipRecord>? slips,
  }) {
    return Tracker(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      customTypeName: customTypeName ?? this.customTypeName,
      quitDate: quitDate ?? this.quitDate,
      dailyCost: dailyCost ?? this.dailyCost,
      dailyFrequency: dailyFrequency ?? this.dailyFrequency,
      currencyCode: currencyCode ?? this.currencyCode,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      slips: slips ?? this.slips,
    );
  }
}
