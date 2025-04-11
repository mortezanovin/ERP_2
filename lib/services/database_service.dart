import 'package:postgres/postgres.dart';
import '../config/db_config.dart';

class DatabaseService {
  late PostgreSQLConnection _connection;

  Future<void> connect() async {
    _connection = PostgreSQLConnection(
      DatabaseConfig.host,
      DatabaseConfig.port,
      DatabaseConfig.databaseName,
      username: DatabaseConfig.username,
      password: DatabaseConfig.password,
    );
    await _connection.open();
  }

  Future<void> close() async {
    await _connection.close();
  }

  Future<List<Map<String, dynamic>>> query(
    String sql, [
    Map<String, dynamic>? parameters,
  ]) async {
    try {
      final result = await _connection.query(
        sql,
        substitutionValues: parameters,
      );
      return result.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      throw Exception('Database query error: $e');
    }
  }

  Future<int> execute(String sql, [Map<String, dynamic>? parameters]) async {
    try {
      return await _connection.execute(sql, substitutionValues: parameters);
    } catch (e) {
      throw Exception('Database execute error: $e');
    }
  }
}
