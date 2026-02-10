import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../app_database.dart';

AppDatabase constructDb() {
  return AppDatabase(LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nomo.db'));
    return NativeDatabase.createInBackground(file);
  }));
}
