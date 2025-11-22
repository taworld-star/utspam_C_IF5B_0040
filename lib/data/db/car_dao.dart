import 'package:sqflite/sqflite.dart';
import '../model/car_model.dart';
import 'db_helper.dart';

class CarDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Get all cars
  Future<List<CarModel>> findAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('cars', orderBy: 'name ASC');
    return result.map((json) => CarModel.fromMap(json)).toList();
  }

  /// Get available cars
  Future<List<CarModel>> findAvailable() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'cars',
      where: 'is_available = 1',
      orderBy: 'name ASC',
    );
    return result.map((json) => CarModel.fromMap(json)).toList();
  }

  /// Get car by ID
  Future<CarModel?> findById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'cars',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return CarModel.fromMap(result.first);
    }
    return null;
  }

  /// Get cars by type
  Future<List<CarModel>> findByType(String type) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'cars',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'name ASC',
    );
    return result.map((json) => CarModel.fromMap(json)).toList();
  }

  /// Search cars by name or type
  Future<List<CarModel>> search(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'cars',
      where: 'name LIKE ? OR type LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((json) => CarModel.fromMap(json)).toList();
  }

  /// Insert new car (Admin only)
  Future<int> insert(CarModel car) async {
    final db = await _dbHelper.database;
    return await db.insert('cars', car.toMap());
  }

  /// Update car
  Future<int> update(CarModel car) async {
    final db = await _dbHelper.database;
    return await db.update(
      'cars',
      car.toMap(),
      where: 'id = ?',
      whereArgs: [car.id],
    );
  }

  /// Update car availability
  Future<int> updateAvailability(int carId, int isAvailable) async {
    final db = await _dbHelper.database;
    return await db.update(
      'cars',
      {'is_available': isAvailable},
      where: 'id = ?',
      whereArgs: [carId],
    );
  }

  /// Delete car
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'cars',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Count total cars
  Future<int> count() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM cars');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Count available cars
  Future<int> countAvailable() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM cars WHERE is_available = 1'
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}