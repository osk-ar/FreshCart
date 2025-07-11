import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LocalDatabaseService {
  static const String _databaseName = "freshcart.db";
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Use a batch to execute all CREATE TABLE statements in one go.
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE Products (
          product_id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          selling_price REAL NOT NULL,
          quantity INTEGER NOT NULL,
          barcode TEXT UNIQUE,
          image_path TEXT UNIQUE
      );
    ''');

    batch.execute('''
      CREATE TABLE InventoryBatches (
          batch_id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER,
          quantity_remaining INTEGER NOT NULL,
          purchase_price REAL NOT NULL,
          production_date TEXT,
          expiry_date TEXT NOT NULL,
          received_date TEXT NOT NULL,
          FOREIGN KEY (product_id) REFERENCES Products (product_id) ON DELETE CASCADE
      );
    ''');

    batch.execute('''
      CREATE TABLE Receipts (
          receipt_id INTEGER PRIMARY KEY AUTOINCREMENT,
          receipt_datetime TEXT NOT NULL,
          total_price REAL NOT NULL,
          total_profit REAL NOT NULL
      );
    ''');

    batch.execute('''
      CREATE TABLE Receipt_Items (
          receipt_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
          receipt_id INTEGER,
          product_id INTEGER,
          batch_id INTEGER,
          quantity INTEGER NOT NULL,
          price_at_sale REAL NOT NULL,
          profit_per_item REAL NOT NULL,
          FOREIGN KEY (receipt_id) REFERENCES Receipts (receipt_id) ON DELETE CASCADE,
          FOREIGN KEY (product_id) REFERENCES Products (product_id) ON DELETE SET NULL,
          FOREIGN KEY (batch_id) REFERENCES InventoryBatches (batch_id) ON DELETE SET NULL
      );
    ''');

    batch.execute('''
      CREATE TABLE Expenses (
          expense_id INTEGER PRIMARY KEY AUTOINCREMENT,
          description TEXT NOT NULL,
          amount REAL NOT NULL,
          expense_date TEXT NOT NULL
      );
    ''');

    await batch.commit(noResult: true);
  }

  static Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
