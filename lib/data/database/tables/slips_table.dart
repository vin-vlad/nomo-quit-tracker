import 'package:drift/drift.dart';

/// Drift table definition for slip records.
class Slips extends Table {
  TextColumn get id => text()();
  TextColumn get trackerId => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
