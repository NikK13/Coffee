import 'dart:convert';

import 'package:coffee/data/model/product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ApiRepository{
  static Future<List<Product>?> fetchProducts([bool popular = false]) async{
    Response? res;
    try{
      res = await Client().get(Uri.parse("https://api.npoint.io/44e5cbcc48d392bed97d"));
      debugPrint("RESPONSE CODE: ${res.statusCode}");
      if(res.statusCode != 200){
        return null;
      }
      else {
        return fetchJsonToList(res.body, popular);
      }
    }
    catch(e){
      debugPrint(e.toString());
      return null;
    }
  }

  static List<Product> fetchJsonToList(String response, [bool popular = false]){
    final data = List<Product>.from(json.decode(response)['products'].map((place) => Product.fromJson(place)));
    return !popular ? data : data.where((Product element) => element.isPopular!).toList();
  }
}