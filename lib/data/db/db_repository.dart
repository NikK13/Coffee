import 'package:coffee/data/model/product.dart';

import 'db_dao.dart';

class ProductsRepository {
  final productsDao = ProductsDao();

  Future getAllProds({String? query}) => productsDao.getProds(query: query);

  Future insertProd(Product prod) => productsDao.addProduct(prod);

  Future updateProd(Product prod) => productsDao.updateProduct(prod);

  Future queryRowCount(String id) => productsDao.queryRowCount(id);

  Future deleteProdById(String id) => productsDao.deleteProduct(id);

  Future deleteAllProducts() => productsDao.deleteAllProducts();
}
