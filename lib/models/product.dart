class Product {
  late int id;
  late String name;
  late String info;

  late double price;
  late int quantity;

  late int userId;
  static const String tableName = 'products';

  Product();

  Product.formMap(Map<String, dynamic> rowMap) {
    id = rowMap['id'];
    name = rowMap['name'];
    info = rowMap['info'];
    price = rowMap['price'];
    quantity = rowMap['quantity'];
    userId = rowMap['user_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['name'] = name;
    map['info'] = info;
    map['price'] = price;
    map['quantity'] = quantity;
    map['user_id'] = userId;
    return map;
  }
}
