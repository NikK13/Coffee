import 'package:coffee/data/utils/appnavigator.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/ui/bloc/fav_bloc.dart';
import 'package:coffee/ui/general/details.dart';
import 'package:coffee/ui/provider/prefsprovider.dart';
import 'package:coffee/ui/widgets/cachedimage.dart';
import 'package:coffee/ui/widgets/ripple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Product{
  String? id;
  String? titleEng;
  String? titleRus;
  String? descEng;
  String? descRus;
  String? image;
  String? type;
  bool? isPopular;

  double? price;
  double? priceS;
  double? priceL;

  Product({
    this.id,
    this.titleEng,
    this.titleRus,
    this.descEng,
    this.descRus,
    this.image,
    this.type,
    this.isPopular,
    this.price,
    this.priceL,
    this.priceS
  });

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'],
      titleEng: json['title_en'],
      titleRus: json['title_ru'],
      descEng: json['desc_en'],
      descRus: json['desc_ru'],
      image: json['image'],
      type: json['type'],
      isPopular: json['popular'],
      price: double.parse(json['price'].toString()),
      priceL: double.parse(json['priceL'].toString()),
      priceS: double.parse(json['priceS'].toString())
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id
  };

  static List<Product>? getSearchList(filter, _list, index, provider) {
    List<dynamic>? _searchList = [];
    if (filter.isEmpty) {
      switch (index) {
        case 0:
          return _searchList = _list;
        case 1:
          return _searchList =
              _list.where((Product element) => element.type == "Coffee").toList();
        case 2:
          return _searchList = _list
              .where((Product element) => element.type == "Tea")
              .toList();
        case 3:
          return _searchList =
              _list.where((Product element) => element.type == "Dessert").toList();
      }
    } else {
      _searchList = _list
          .where((Product element) =>
      (provider.locale!.languageCode == "en" ? element.titleEng : element.titleRus)!
          .toLowerCase().contains(filter.toLowerCase())).toList();
    }
    return _searchList as List<Product>?;
  }
}

class ProductItem extends StatelessWidget {
  final Product? product;
  final FavoritesBloc? favBloc;

  const ProductItem({Key? key, this.product, this.favBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Ripple(
        radius: 20,
        rippleColor: Theme.of(context).brightness == Brightness.dark ?
        Colors.black12 : Colors.white,
        onTap: () async {
          await favBloc!.initItemWithDB(product!);
          AppNavigator.of(context).push(ProductDetails(
            product: product, favBloc: favBloc,
          ));
        },
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedImage(
                  url: product!.image,
                  radius: 20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    " ${provider.locale!.languageCode == "en" ?
                    product!.titleEng : product!.titleRus}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  ),
                  //const SizedBox(height: 2),
                  Text(
                    " ${getRealPrice(
                      product!.price!,
                      product!.priceS!,
                      product!.priceL!,
                    )} BYN",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}