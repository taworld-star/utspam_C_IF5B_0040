import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user_model.dart';
import '../model/car_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('car_rental.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabel Users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        nik TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Tabel Cars
    await db.execute('''
      CREATE TABLE cars (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        image TEXT,
        price_per_day INTEGER NOT NULL,
        year INTEGER NOT NULL,
        transmission TEXT NOT NULL,
        seats INTEGER NOT NULL,
        is_available INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Insert dummy cars
    await _insertDummyCars(db);
  }

  Future _insertDummyCars(Database db) async {
    final cars = [
      {
        'name': 'Toyota Avanza',
        'type': 'MPV',
        'image': 'assets/images/avanza.png',
        'price_per_day': 350000,
        'year': 2023,
        'transmission': 'Manual',
        'seats': 7,
        'is_available': 1,
      },
      {
        'name': 'Honda Civic',
        'type': 'Sedan',
        'image': 'assets/images/civic.png',
        'price_per_day': 500000,
        'year': 2024,
        'transmission': 'Automatic',
        'seats': 5,
        'is_available': 1,
      },
      {
        'name': 'Mitsubishi Xpander',
        'type': 'MPV',
        'image': 'assets/images/xpander.png',
        'price_per_day': 400000,
        'year': 2023,
        'transmission': 'Automatic',
        'seats': 7,
        'is_available': 1,
      },
    ];

    for (var car in cars) {
      await db.insert('cars', car);
    }
  }

  // ========== USER CRUD ==========
  
  // Create User (Register)
  Future<int> createUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Read User by Username (Login)
  Future<UserModel?> getUserByUsername(String username) async {
    final db = await database;
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

  // Check if username exists
  Future<bool> isUsernameExists(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // Update User
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete User
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== CAR CRUD ==========
  
  // Get all cars
  Future<List<CarModel>> getAllCars() async {
    final db = await database;
    final result = await db.query('cars');
    return result.map((json) => CarModel.fromMap(json)).toList();
  }

  // Get available cars
  Future<List<CarModel>> getAvailableCars() async {
    final db = await database;
    final result = await db.query(
      'cars',
      where: 'is_available = ?',
      whereArgs: [1],
    );
    return result.map((json) => CarModel.fromMap(json)).toList();
  }

  // Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}