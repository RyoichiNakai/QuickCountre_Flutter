import 'package:quick_countre/databases/db_provider/database_provider.dart';

class DbProviderMode2 extends DatabaseProvider {
  @override
  String get databaseName => 'QuickCountre_mode2.db';

  @override
  String get tableName => 'mode2Score';
}