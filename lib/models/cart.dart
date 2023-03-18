class Cart {
  late int id;
  late int count;
  late double total;
  late double price;
  late int userId;
  late int productId;
  late String productName ;
  static const String tableName = 'carts';

  Cart();

  Cart.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap['id'];
    count = rowMap['count'];
    total = rowMap['total'];
    price = rowMap['price'];
    userId = rowMap['user_id'];
    productId = rowMap['product_id'];
    productName = rowMap['name'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['count'] = count;
    map['total'] = total;
    map['price'] = price;
    map['user_id'] = userId;
    map['product_id'] = productId;
    return map;
  }
}
