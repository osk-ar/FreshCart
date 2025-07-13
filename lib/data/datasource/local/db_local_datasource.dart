import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBLocalDatasource {
  final Database db;

  DBLocalDatasource(this.db);

  //* --- Product Management ---

  /// Adds a new product to the Products table.
  Future<int> addProduct({
    required String name,
    required double sellingPrice,
    required int quantity,
    String? imagePath,
  }) async {
    return await db.insert('Products', {
      'name': name,
      'selling_price': sellingPrice,
      'quantity': quantity,
      'image_path': imagePath,
    });
  }

  /// Updates an existing product's details.
  Future<int> updateProduct({
    required int productId,
    required String name,
    required double sellingPrice,
    required int quantity,
    String? imagePath,
  }) async {
    return await db.update(
      'Products',
      {
        'name': name,
        'selling_price': sellingPrice,
        'quantity': quantity,
        'image_path': imagePath,
      },
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  /// Deletes a product and its associated inventory batches (due to ON DELETE CASCADE).
  Future<int> deleteProduct(int productId) async {
    return await db.delete(
      'Products',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  /// Retrieves all products from the database.
  Future<List<Map<String, dynamic>>> getAllProducts({
    int? limit,
    int? offset,
  }) async {
    return await db.query(
      'Products',
      orderBy: 'name ASC',
      limit: limit,
      offset: offset,
    );
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    final products = await db.query(
      'Products',
      where: 'product_id = ?',
      whereArgs: [id],
    );

    return products.first;
  }

  Future<List<Map<String, dynamic>>> searchProducts(
    String query, {
    int? limit,
    int? offset,
  }) async {
    return await db.query(
      'Products',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
      limit: limit,
      offset: offset,
    );
  }

  //* --- Inventory & Batch Management ---

  /// Restocks an item by adding a new entry to the InventoryBatches table.
  Future<int> restockItem({
    required int productId,
    required int quantity,
    required double purchasePrice,
    required DateTime expiryDate,
    DateTime? productionDate,
  }) async {
    return await db.transaction((txn) async {
      await txn.insert('InventoryBatches', {
        'product_id': productId,
        'quantity_remaining': quantity,
        'purchase_price': purchasePrice,
        'production_date': productionDate?.toIso8601String().split('T').first,
        'expiry_date': expiryDate.toIso8601String().split('T').first,
        'received_date': DateTime.now().toIso8601String().split('T').first,
      });

      return await txn.update(
        'Products',
        {'quantity': (await getProductStockCount(productId)) + quantity},
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    });
  }

  /// Updates the details of a specific inventory batch.
  Future<int> updateBatch({
    required int batchId,
    required int quantity,
    required double purchasePrice,
    required DateTime expiryDate,
    DateTime? productionDate,
  }) async {
    return await db.update(
      'InventoryBatches',
      {
        'quantity_remaining': quantity,
        'purchase_price': purchasePrice,
        'production_date': productionDate?.toIso8601String().split('T').first,
        'expiry_date': expiryDate.toIso8601String().split('T').first,
      },
      where: 'batch_id = ?',
      whereArgs: [batchId],
    );
  }

  /// Retrieves all inventory batches for a given product.
  Future<List<Map<String, dynamic>>> getBatchesForProduct(int productId) async {
    return await db.query(
      'InventoryBatches',
      where: 'product_id = ? AND quantity_remaining > 0',
      whereArgs: [productId],
      orderBy: 'expiry_date ASC', // Show soon-to-expire items first
    );
  }

  /// Gets the total stock quantity for a specific product across all batches.
  Future<int> getProductStockCount(int productId) async {
    final result = await db.rawQuery(
      '''
          SELECT SUM(quantity_remaining) as total_stock
          FROM InventoryBatches
          WHERE product_id = ?
      ''',
      [productId],
    );

    if (result.isNotEmpty && result.first['total_stock'] != null) {
      return result.first['total_stock'] as int;
    }
    return 0;
  }

  //* --- Sales & Receipt Processing ---

  /// Creates a receipt in a single, atomic transaction.
  /// Takes a list of cart items, where each item is a map:
  /// {'product_id': int, 'quantity': int}
  Future<int> createReceipt(List<Map<String, dynamic>> cartItems) async {
    return await db.transaction((txn) async {
      double totalReceiptPrice = 0;
      double totalReceiptProfit = 0;

      // Step 1: Create the main receipt record first, we'll update totals later.
      final receiptId = await txn.insert('Receipts', {
        'receipt_datetime': DateTime.now().toIso8601String(),
        'total_price': 0, // Placeholder
        'total_profit': 0, // Placeholder
      });

      // Step 2: Process each item in the cart.
      for (var item in cartItems) {
        int productId = item['product_id'];
        int quantityToSell = item['quantity'];

        // Get product details (specifically selling price)
        final productDetailsList = await txn.query(
          'Products',
          where: 'product_id = ?',
          whereArgs: [productId],
        );
        if (productDetailsList.isEmpty) {
          throw Exception('Product with ID $productId not found.');
        }
        final sellingPrice =
            productDetailsList.first['selling_price'] as double;

        // Get available batches for this product, ordered by expiry date (FEFO - First Expired, First Out)
        final availableBatches = await txn.query(
          'InventoryBatches',
          where:
              'product_id = ? AND quantity_remaining > 0 AND expiry_date >= ?',
          whereArgs: [
            productId,
            DateTime.now().toIso8601String().split('T').first,
          ],
          orderBy: 'expiry_date ASC',
        );

        // Step 3: Deduct quantity from available batches
        for (var batch in availableBatches) {
          if (quantityToSell <= 0) break;

          int batchId = batch['batch_id'] as int;
          int batchQuantity = batch['quantity_remaining'] as int;
          double purchasePrice = batch['purchase_price'] as double;

          int sellFromThisBatch =
              (quantityToSell > batchQuantity) ? batchQuantity : quantityToSell;

          double profitPerItem = sellingPrice - purchasePrice;

          // Add to receipt item log
          await txn.insert('Receipt_Items', {
            'receipt_id': receiptId,
            'product_id': productId,
            'batch_id': batchId,
            'quantity': sellFromThisBatch,
            'price_at_sale': sellingPrice,
            'profit_per_item': profitPerItem,
          });

          // Update totals
          totalReceiptPrice += sellFromThisBatch * sellingPrice;
          totalReceiptProfit += sellFromThisBatch * profitPerItem;

          // Decrease remaining quantity in the batch
          await txn.update(
            'InventoryBatches',
            {'quantity_remaining': batchQuantity - sellFromThisBatch},
            where: 'batch_id = ?',
            whereArgs: [batchId],
          );

          quantityToSell -= sellFromThisBatch;
        }

        if (quantityToSell > 0) {
          // This means there wasn't enough stock to fulfill the order.
          // The transaction will be rolled back automatically on exception.
          throw Exception('Not enough stock for product ID $productId.');
        }
      }

      // Step 4: Update the receipt with the final calculated totals.
      await txn.update(
        'Receipts',
        {'total_price': totalReceiptPrice, 'total_profit': totalReceiptProfit},
        where: 'receipt_id = ?',
        whereArgs: [receiptId],
      );

      return receiptId;
    });
  }

  //* --- Expired Item Management ---

  /// Finds all batches that are expired and still have items in stock.
  Future<List<Map<String, dynamic>>> getExpiredBatches() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    return db.rawQuery(
      '''
      SELECT b.*, p.name
      FROM InventoryBatches b
      JOIN Products p ON b.product_id = p.product_id
      WHERE b.expiry_date < ? AND b.quantity_remaining > 0
    ''',
      [today],
    );
  }

  /// Processes all expired items: adds their cost to expenses and removes them from stock.
  Future<void> processExpiredItems() async {
    final expiredBatches = await getExpiredBatches();

    if (expiredBatches.isEmpty) return;

    await db.transaction((txn) async {
      for (var batch in expiredBatches) {
        final loss =
            (batch['quantity_remaining'] as int) *
            (batch['purchase_price'] as double);
        final batchId = batch['batch_id'] as int;

        // Add loss to expenses
        await txn.insert('Expenses', {
          'description': 'Expired Stock: ${batch['name']} (Batch #$batchId)',
          'amount': loss,
          'expense_date': DateTime.now().toIso8601String().split('T').first,
        });

        // Set batch quantity to zero
        await txn.update(
          'InventoryBatches',
          {'quantity_remaining': 0},
          where: 'batch_id = ?',
          whereArgs: [batchId],
        );
      }
    });
  }

  //* --- Statistics & Reporting ---

  /// 1. Chart with profit/datetime
  Future<List<Map<String, dynamic>>> getProfitByDate() async {
    return await db.rawQuery('''
      SELECT
          DATE(receipt_datetime) as date,
          SUM(total_profit) as daily_profit
      FROM Receipts
      GROUP BY date
      ORDER BY date ASC;
    ''');
  }

  /// 2. Top 3 most sold items
  Future<List<Map<String, dynamic>>> getTopSoldProducts({int limit = 3}) async {
    return await db.rawQuery(
      '''
      SELECT
          p.name,
          SUM(ri.quantity) as total_quantity_sold
      FROM Receipt_Items ri
      JOIN Products p ON ri.product_id = p.product_id
      GROUP BY p.name
      ORDER BY total_quantity_sold DESC
      LIMIT ?;
    ''',
      [limit],
    );
  }

  /// 3. Total income
  Future<double> getTotalIncome() async {
    final result = await db.rawQuery(
      'SELECT SUM(total_price) as total_income FROM Receipts;',
    );
    return (result.first['total_income'] as double?) ?? 0.0;
  }

  /// 4. Total outgoing
  Future<double> getTotalOutgoing() async {
    // Cost of goods sold
    final cogsResult = await db.rawQuery('''
        SELECT SUM(ri.quantity * ib.purchase_price) as cogs
        FROM Receipt_Items ri
        JOIN InventoryBatches ib ON ri.batch_id = ib.batch_id
    ''');
    final cogs = (cogsResult.first['cogs'] as double?) ?? 0.0;

    // Other expenses
    final expensesResult = await db.rawQuery(
      'SELECT SUM(amount) as total_expenses FROM Expenses;',
    );
    final otherExpenses =
        (expensesResult.first['total_expenses'] as double?) ?? 0.0;

    return cogs + otherExpenses;
  }

  /// 5. Receipts with datetime - price - profit
  Future<List<Map<String, dynamic>>> getAllReceipts() async {
    return await db.query('Receipts', orderBy: 'receipt_datetime DESC');
  }
}
