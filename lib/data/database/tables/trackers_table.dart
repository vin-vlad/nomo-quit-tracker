import 'package:drift/drift.dart';

/// Drift table definition for trackers.
class Trackers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get addictionTypeId => text()();
  TextColumn get customTypeName => text().nullable()();
  DateTimeColumn get quitDate => dateTime()();
  RealColumn get dailyCost => real().nullable()();
  IntColumn get dailyFrequency => integer().nullable()();
  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
