import 'package:quick_countre/databases/db_provider/database_provider.dart';

class DbProviderMode3 extends DatabaseProvider {
  @override
  String get databaseName => 'QuickCountre_mode3.db';

  @override
  String get tableName => 'mode3Score';
}