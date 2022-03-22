import 'dart:async';
import 'package:coffee/data/db/db.dart';
import 'package:coffee/data/model/product.dart';

class ProductsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Todo records
  Future<int> addProduct(Product product) async {
    final db = await dbProvider.database;
    var result = db!.insert(prodsTable, product.toJson());
    return result;
  }

  //Get All Todo items
  //Searches if query string was passed
  Future<List<Product>> getProds({List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    late List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db!.query(
          prodsTable,
          columns: columns,
          where: 'description LIKE ?',
          whereArgs: ["%$query%"]
        );
      }
    } else {
      result = await db!.query(prodsTable, columns: columns);
    }

    List<Product> products = result.isNotEmpty
      ? result.map((item) => Product(id: item['id'])).toList()
      : [];
    return products;
  }

  Future<int> queryRowCount(String rowID) async {
    final db = await dbProvider.database;
    var res = await db!.rawQuery("SELECT * FROM $prodsTable WHERE id LIKE '%$rowID%'");
    return res.isNotEmpty ? 1 : 0;
  }

  //Update Todo record
  Future<int> updateProduct(Product product) async {
    final db = await dbProvider.database;
    var result = await db!.update(prodsTable, product.toJson(),
        where: "id = ?", whereArgs: [product.id]);
    return result;
  }

  //Delete Todo records
  Future<int> deleteProduct(String id) async {
    final db = await dbProvider.database;
    var result = await db!.delete(prodsTable, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllProducts() async {
    final db = await dbProvider.database;
    var result = await db!.delete(prodsTable);

    return result;
  }
}
