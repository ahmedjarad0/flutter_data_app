import 'package:database/database/controllers/products_db_controller.dart';
import 'package:database/models/product.dart';
import 'package:database/models/response_process.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> products = <Product>[];
  final ProductsDbController _dbController = ProductsDbController();

  Future<ProcessResponses> create(Product product) async {
    int newRowsId = await _dbController.create(product);
    if (newRowsId != 0) {
      product.id = newRowsId;
      products.add(product);
      notifyListeners();
    }
    return getResponse(newRowsId != 0);
  }

  void read() async {
    products = await _dbController.read();
    notifyListeners();
  }


  Future<ProcessResponses> delete(int index)async{
    bool deleted = await  _dbController.delete(products[index].id);
    if(deleted){
      products.removeAt(index);
      notifyListeners();
    }
    return getResponse(deleted);
  }

  Future<ProcessResponses> update(Product product) async {
    bool updated = await _dbController.update(product);
    if (updated) {
      int index = products.indexWhere((element) => element.id == product.id);
      if (index != -1) {
        products[index] = product;
        notifyListeners();
      }
    }
    return getResponse(updated);
  }

ProcessResponses getResponse(bool success) {
  return ProcessResponses(
      message: success ? 'Operation is Successfully' : 'Operation failed',
      success: success);
}
}

