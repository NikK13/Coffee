import 'dart:async';
import 'package:coffee/data/db/db_repository.dart';
import 'package:coffee/data/model/product.dart';
import 'package:coffee/data/repository/api_repository.dart';
import 'package:coffee/ui/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';


class FavoritesBloc extends BaseBloc{
  final prodsRepository = ProductsRepository();

  final _liked = BehaviorSubject<bool>();
  final _products = BehaviorSubject<List<Product>>();

  Stream<bool> get isLikedStream => _liked.stream;
  Stream<List<Product>> get listStream => _products.stream;

  Function(bool) get changeLiked => _liked.sink.add;
  Function(List<Product>) get loadProducts => _products.sink.add;

  List<Product>? allProducts;

  FavoritesBloc(){
    loadAllProducts().then((value){
      getAllData();
    });
  }

  Future loadAllProducts() async{
    allProducts = await ApiRepository.fetchProducts();
  }

  initialize(Product? product) {
    if (product != null) initItemWithDB(product);
    getAllData();
  }

  initItemWithDB(Product product) async {
    final res = await queryCount(product.id!);
    final isLiked = res > 0 ? true : false;
    await changeLiked(isLiked);
  }

  getAllData() async {
    final List<Product> ids = await (prodsRepository.getAllProds() as Future<List<Product>>);
    final List<Product> all = [];
    if(allProducts != null){
      if(ids.isNotEmpty){
        for(int i = 0; i < ids.length; i++){
          final Product? item = allProducts!.firstWhere((element) => element.id == ids[i].id);
          if(item != null){
            all.add(item);
          }
        }
      }
    }
    await loadProducts(all.reversed.toList());
  }

  queryCount(String id) async {
    var res = await prodsRepository.queryRowCount(id);
    await getAllData();
    //debugPrint("$res");
    return res;
  }

  addProduct(Product product) async {
    await prodsRepository.insertProd(product);
    await getAllData();
  }

  updateProduct(Product product) async {
    await prodsRepository.updateProd(product);
    await getAllData();
  }

  deleteProductByID(String id) async {
    await prodsRepository.deleteProdById(id);
    await getAllData();
  }

  deleteAllPlaces() async {
    await prodsRepository.deleteAllProducts();
    await getAllData();
  }

  @override
  void dispose() {
    _liked.close();
    _products.close();
  }
}
