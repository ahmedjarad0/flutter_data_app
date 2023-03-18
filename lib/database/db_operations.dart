import 'package:database/database/db_controller.dart';
import 'package:sqflite/sqflite.dart';

abstract class DbOperation<Model> {

  final Database database = DbController().database;
  Future<int> create(Model model);

  Future<List<Model>> read();

  Future<bool> update(Model model);

  Future<bool> delete(int id);

  Future<Model?> show(int id);
  Future<void> clear()async{

  }
}
