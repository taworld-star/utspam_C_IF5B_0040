import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      version: 2, 
      onCreate: _createDB,
      onUpgrade: _onUpgrade, 
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

    // Tabel Rentals
    await db.execute('''
      CREATE TABLE rentals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        car_id INTEGER NOT NULL,
        car_name TEXT NOT NULL,
        renter_name TEXT NOT NULL,
        rental_days INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        total_price INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'active',
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (car_id) REFERENCES cars (id)
      )
    ''');

    // Insert dummy cars
    await _insertDummyCars(db);
  }

  
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print(' Upgrading database from v$oldVersion to v$newVersion');
    
    if (oldVersion < 2) {
      // Cek apakah tabel rentals sudah ada
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='rentals'"
      );
      
      if (result.isEmpty) {
        print('➕ Creating rentals table...');
        await db.execute('''
          CREATE TABLE rentals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            car_id INTEGER NOT NULL,
            car_name TEXT NOT NULL,
            renter_name TEXT NOT NULL,
            rental_days INTEGER NOT NULL,
            start_date TEXT NOT NULL,
            end_date TEXT NOT NULL,
            total_price INTEGER NOT NULL,
            status TEXT NOT NULL DEFAULT 'active',
            created_at TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id),
            FOREIGN KEY (car_id) REFERENCES cars (id)
          )
        ''');
        print(' Rentals table created successfully');
      } else {
        print(' Rentals table already exists');
      }
    }
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
      {
        'name': 'Toyota Fortuner',
        'type': 'SUV',
        'image': 'assets/images/fortuner.png',
        'price_per_day': 800000,
        'year': 2024,
        'transmission': 'Automatic',
        'seats': 7,
        'is_available': 1,
      },
      {
        'name': 'Suzuki Ertiga',
        'type': 'MPV',
        'image': 'assets/images/ertiga.png',
        'price_per_day': 300000,
        'year': 2023,
        'transmission': 'Manual',
        'seats': 7,
        'is_available': 1,
      },
    ];

    for (var car in cars) {
      await db.insert('cars', car);
    }
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}