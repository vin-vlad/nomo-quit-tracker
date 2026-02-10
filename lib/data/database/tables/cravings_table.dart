import 'package:drift/drift.dart';

/// Drift table definition for cravings.
class Cravings extends Table {
  TextColumn get id => text()();
  TextColumn get trackerId => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get intensity => integer().nullable()();
  TextColumn get trigger => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
