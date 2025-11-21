import 'package:sqflite/sqflite.dart';
import '../model/rental_model.dart';
import 'db_helper.dart';

class RentalDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Create Rental
  Future<int> insert(RentalModel rental) async {
    final db = await _dbHelper.database;

    // Update car availability to not available
    await db.update(
      'cars',
      {'is_available': 0},
      where: 'id = ?',
      whereArgs: [rental.carId],
    );

    return await db.insert('rentals', rental.toMap());
  }

  /// Get all rentals by user
  Future<List<RentalModel>> findByUserId(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'rentals',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return result.map((json) => RentalModel.fromMap(json)).toList();
  }

  /// Get active rentals by user
  Future<List<RentalModel>> findActiveByUserId(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'rentals',
      where: 'user_id = ? AND status = ?',
      whereArgs: [userId, 'active'],
      orderBy: 'created_at DESC',
    );
    return result.map((json) => RentalModel.fromMap(json)).toList();
  }

  /// Get completed rentals by user
  Future<List<RentalModel>> findCompletedByUserId(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'rentals',
      where: 'user_id = ? AND status = ?',
      whereArgs: [userId, 'completed'],
      orderBy: 'created_at DESC',
    );
    return result.map((json) => RentalModel.fromMap(json)).toList();
  }

  /// Get cancelled rentals by user
  Future<List<RentalModel>> findCancelledByUserId(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'rentals',
      where: 'user_id = ? AND status = ?',
      whereArgs: [userId, 'cancelled'],
      orderBy: 'created_at DESC',
    );
    return result.map((json) => RentalModel.fromMap(json)).toList();
  }

  /// Get rentals by status (all users - admin)
  Future<List<RentalModel>> findByStatus(String status) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'rentals',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );
    return result.map((json) => RentalModel.fromMap(json)).toList();
  }

  /// Get rental by ID
  Future<RentalModel?> findById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'rentals',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return RentalModel.fromMap(result.first);
    }
    return null;
  }

  /// Update rental
  Future<int> update(RentalModel rental) async {
    final db = await _dbHelper.database;
    return await db.update(
      'rentals',
      rental.toMap(),
      where: 'id = ?',
      whereArgs: [rental.id],
    );
  }

  /// Update rental status
  Future<int> updateStatus(int id, String status) async {
    final db = await _dbHelper.database;

    // If completed or cancelled, make car available again
    if (status == 'completed' || status == 'cancelled') {
      final rental = await db.query('rentals', where: 'id = ?', whereArgs: [id]);
      if (rental.isNotEmpty) {
        await db.update(
          'cars',
          {'is_available': 1},
          where: 'id = ?',
          whereArgs: [rental.first['car_id']],
        );
      }
    }

    return await db.update(
      'rentals',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete rental
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;

    // Make car available again
    final rental = await db.query('rentals', where: 'id = ?', whereArgs: [id]);
    if (rental.isNotEmpty) {
      await db.update(
        'cars',
        {'is_available': 1},
        where: 'id = ?',
        whereArgs: [rental.first['car_id']],
      );
    }

    return await db.delete(
      'rentals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get all rentals (Admin only)
  Future<List<RentalModel>> findAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('rentals', orderBy: 'created_at DESC');
    return result.map((json) => RentalModel.fromMap(json)).toList();
  }

  /// Get rental statistics by user
  Future<Map<String, int>> getStatsByUserId(int userId) async {
    final db = await _dbHelper.database;

    final total = await db.query('rentals', where: 'user_id = ?', whereArgs: [userId]);
    final active = await db.query('rentals', where: 'user_id = ? AND status = ?', whereArgs: [userId, 'active']);
    final completed = await db.query('rentals', where: 'user_id = ? AND status = ?', whereArgs: [userId, 'completed']);
    final cancelled = await db.query('rentals', where: 'user_id = ? AND status = ?', whereArgs: [userId, 'cancelled']);

    return {
      'total': total.length,
      'active': active.length,
      'completed': completed.length,
      'cancelled': cancelled.length,
    };
  }

  /// Count total rentals
  Future<int> count() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM rentals');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Count rentals by status
  Future<int> countByStatus(String status) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM rentals WHERE status = ?',
      [status]
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get total revenue (all completed rentals)
  Future<int> getTotalRevenue() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(total_price) as total FROM rentals WHERE status = ?',
      ['completed']
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get total revenue by user
  Future<int> getTotalRevenueByUserId(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(total_price) as total FROM rentals WHERE user_id = ? AND status = ?',
      [userId, 'completed']
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}