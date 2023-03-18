import 'package:database/database/controllers/carts_db_controller.dart';
import 'package:database/models/cart.dart';
import 'package:database/models/response_process.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> cartItems = <Cart>[];
  final CartDbController _dbController = CartDbController();
  double total = 0;
  double quantity = 0;

  Future<ProcessResponses> create(Cart cart) async {
    int index =
        cartItems.indexWhere((element) => element.productId == cart.productId);
    if (index == -1) {
      int newRowsId = await _dbController.create(cart);
      if (newRowsId != 0) {
        total += cart.total;
        quantity+= 1 ;
        cart.id = newRowsId;

        cartItems.add(cart);
        notifyListeners();
      }
      return getResponse(newRowsId != 0);
    } else {
      int newCount = cartItems[index].count + 1;
      return (changQuantity(index, newCount));
    }
  }

  void read() async {
    cartItems = await _dbController.read();
    for (Cart cart in cartItems) {
      total += cart.total;
      quantity+= 1;
    }
    notifyListeners();
  }

  Future<ProcessResponses> clear() async {
    bool cleared = await _dbController.clear();
    if (cleared) {
      cartItems.clear();
      total = 0;
      quantity =0;
      notifyListeners();
    }
    return getResponse(cleared);
  }

  Future<ProcessResponses> changQuantity(int index, int count) async {
    bool isDeleted = count == 0;
    Cart cart = cartItems[index];

    bool result = isDeleted
        ? await _dbController.delete(cart.id)
        : await _dbController.update(cart);
    if (result) {
      if (isDeleted) {
        total -= cart.total;
        quantity -= 1 ;
        cartItems.removeAt(index);
      } else {
        cart.count = count;
        cart.total = cart.count * cart.price;
        total += cart.total;
        quantity += 1 ;
        cartItems[index] = cart;
      }
      notifyListeners();
    }
    return getResponse(result);
  }

  ProcessResponses getResponse(bool success) {
    return ProcessResponses(
        message: success ? 'Operation is Successfully' : 'Operation failed',
        success: success);
  }
}
