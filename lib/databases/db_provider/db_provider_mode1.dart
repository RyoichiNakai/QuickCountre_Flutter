import 'package:quick_countre/databases/db_provider/database_provider.dart';

class DbProviderMode1 extends DatabaseProvider {
  @override
  String get databaseName => 'QuickCountre_mode1.db';

  @override
  String get tableName => 'mode1Score';
}