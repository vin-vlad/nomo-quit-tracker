import '../../domain/entities/addiction_type.dart';

/// All built-in addiction type presets.
class AddictionTypePresets {
  AddictionTypePresets._();

  // ── Free-tier types ───────────────────────────────────────────────
  static const smoking = AddictionType(
    id: 'smoking',
    name: 'Smoking',
    icon: 'smoking',
    category: AddictionCategory.substance,
    isPremium: false,
  );

  static const vaping = AddictionType(
    id: 'vaping',
    name: 'Vaping',
    icon: 'vaping',
    category: AddictionCategory.substance,
    isPremium: false,
  );

  static const alcohol = AddictionType(
    id: 'alcohol',
    name: 'Alcohol',
    icon: 'alcohol',
    category: AddictionCategory.substance,
    isPremium: false,
  );

  static const caffeine = AddictionType(
    id: 'caffeine',
    name: 'Caffeine',
    icon: 'caffeine',
    category: AddictionCategory.dietary,
    isPremium: false,
  );

  static const custom = AddictionType(
    id: 'custom',
    name: 'Custom',
    icon: 'custom',
    category: AddictionCategory.custom,
    isPremium: false,
  );

  // ── Premium types ─────────────────────────────────────────────────
  static const sugar = AddictionType(
    id: 'sugar',
    name: 'Sugar',
    icon: 'sugar',
    category: AddictionCategory.dietary,
    isPremium: true,
  );

  static const socialMedia = AddictionType(
    id: 'social_media',
    name: 'Social Media',
    icon: 'social_media',
    category: AddictionCategory.digital,
    isPremium: true,
  );

  static const gambling = AddictionType(
    id: 'gambling',
    name: 'Gambling',
    icon: 'gambling',
    category: AddictionCategory.behavioral,
    isPremium: true,
  );

  static const shopping = AddictionType(
    id: 'shopping',
    name: 'Shopping',
    icon: 'shopping',
    category: AddictionCategory.behavioral,
    isPremium: true,
  );

  static const nailBiting = AddictionType(
    id: 'nail_biting',
    name: 'Nail Biting',
    icon: 'nail_biting',
    category: AddictionCategory.behavioral,
    isPremium: true,
  );

  static const junkFood = AddictionType(
    id: 'junk_food',
    name: 'Junk Food',
    icon: 'junk_food',
    category: AddictionCategory.dietary,
    isPremium: true,
  );

  static const porn = AddictionType(
    id: 'porn',
    name: 'Porn',
    icon: 'porn',
    category: AddictionCategory.behavioral,
    isPremium: true,
  );

  static const gaming = AddictionType(
    id: 'gaming',
    name: 'Gaming',
    icon: 'gaming',
    category: AddictionCategory.digital,
    isPremium: true,
  );

  static const drugs = AddictionType(
    id: 'drugs',
    name: 'Drugs',
    icon: 'drugs',
    category: AddictionCategory.substance,
    isPremium: true,
  );

  static const List<AddictionType> freeTypes = [
    smoking,
    vaping,
    alcohol,
    caffeine,
    custom,
  ];

  static const List<AddictionType> premiumTypes = [
    sugar,
    socialMedia,
    gambling,
    shopping,
    nailBiting,
    junkFood,
    porn,
    gaming,
    drugs,
  ];

  static const List<AddictionType> all = [
    ...freeTypes,
    ...premiumTypes,
  ];

  static AddictionType byId(String id) {
    return all.firstWhere(
      (t) => t.id == id,
      orElse: () => custom,
    );
  }
}
