/// Category of addiction.
enum AddictionCategory {
  substance,
  behavioral,
  dietary,
  digital,
  custom,
}

/// Defines a type of addiction/habit the user can quit.
class AddictionType {
  final String id;
  final String name;
  final String icon;
  final AddictionCategory category;
  final bool isPremium;

  const AddictionType({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    required this.isPremium,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddictionType &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
