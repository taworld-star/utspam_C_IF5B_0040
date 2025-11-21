import 'package:sqflite/sqflite.dart';
import '../model/user_model.dart';
import 'db_helper.dart';

class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Create User (Register)
  Future<int> insert(UserModel user) async {
    final db = await _dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  /// Read User by Username (Login)
  Future<UserModel?> findByUsername(String username) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  /// Read User by ID
  Future<UserModel?> findById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  /// Check if username exists
  Future<bool> isUsernameExists(String username) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  /// Get all users
  Future<List<UserModel>> findAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('users', orderBy: 'name ASC');
    return result.map((json) => UserModel.fromMap(json)).toList();
  }

  /// Update User
  Future<int> update(UserModel user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Delete User
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Count total users
  Future<int> count() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM users');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}