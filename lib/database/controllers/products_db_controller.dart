import 'package:database/database/db_operations.dart';
import 'package:database/models/product.dart';
import 'package:database/pref/shared_pref.dart';

class ProductsDbController extends DbOperation<Product> {
  @override
  Future<int> create(Product model) async {
    return await database.rawInsert(
        'INSERT INTO products(name,info,price,quantity,user_id) VALUES(?,?,?,?,?)',
        [model.name, model.info, model.price, model.quantity, model.userId]);
  }

  @override
  Future<bool> delete(int id) async {
    int newDeletedRow =
        await database.rawDelete('DELETE FROM products WHERE id =?', [id]);
    return newDeletedRow != 0;
  }

  @override
  Future<List<Product>> read() async {
    int userId = SharedPerfController().getValue<int>(PerfKeys.id.name)!;
    List<Map<String, dynamic>> rowsMap = await database
        .rawQuery('SELECT * FROM products WHERE user_id =?', [userId]);
    return rowsMap.map((rowMap) => Product.formMap(rowMap)).toList();
  }

  @override
  Future<Product?> show(int id) async {
    List<Map<String, dynamic>> rowsMap =
        await database.rawQuery('SELECT * FROM products WHERE id=?', [id]);
    return rowsMap.isNotEmpty ? Product.formMap(rowsMap.first) : null;
  }

  @override
  Future<bool> update(Product model) async {
    int userId = SharedPerfController().getValue<int>(PerfKeys.id.name)!;

    int updatedRowId = await database.rawUpdate(
        'UPDATE products SET name = ? ,info = ? ,price = ? ,quantity = ? WHERE id =? AND user_id = ? ',
        [
          model.name,
          model.info,
          model.price,
          model.quantity,
          model.id,
          userId
        ]);
    return updatedRowId != 0;
  }
}
