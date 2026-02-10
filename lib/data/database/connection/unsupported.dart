import '../app_database.dart';

AppDatabase constructDb() {
  throw UnsupportedError(
    'No suitable database implementation found for this platform.',
  );
}
