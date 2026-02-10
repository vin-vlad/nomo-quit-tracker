import 'package:drift/web.dart';
import '../app_database.dart';

AppDatabase constructDb() {
  return AppDatabase(WebDatabase('nomo_db'));
}
