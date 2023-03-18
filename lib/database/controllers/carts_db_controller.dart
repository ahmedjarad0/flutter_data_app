import 'package:database/database/db_operations.dart';
import 'package:database/models/cart.dart';
import 'package:database/pref/shared_pref.dart';

class CartDbController extends DbOperation<Cart> {
  int userId = SharedPerfController().getValue<int>(PerfKeys.id.name)!;

  @override
  Future<int> create(Cart model) async {
    return await database.insert(Cart.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    int countDeletedRow = await database.delete(Cart.tableName,
        where: 'id = ? AND user_id = ?', whereArgs: [id, userId]);
    return countDeletedRow != 0;
  }

  @override
  Future<List<Cart>> read() async {
    List<Map<String, dynamic>> rowsMap = await database.rawQuery(
        ''
        'SELECT carts.id, carts.product_id, carts.count, carts.total, carts.price, carts.user_id, products.name '
        'FROM carts JOIN products  ON carts.product_id = products.id '
        'WHERE carts.user_id = ?',
        [userId]);
    print(rowsMap);
    return rowsMap.map((rowsMap) => Cart.fromMap(rowsMap)).toList();
  }

  @override
  Future<Cart?> show(int id) {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Cart model) async {
    int updatedRowsCount = await database.update(Cart.tableName, model.toMap(),
        where: 'id =? AND user_id = ?', whereArgs: [model.id, userId]);
    return updatedRowsCount != 0;
  }

  @override
  Future<bool> clear() async {
    int countOfDeleted = await database
        .delete(Cart.tableName, where: 'user_id = ?', whereArgs: [userId]);
    return countOfDeleted!= 0 ;
  }
}
