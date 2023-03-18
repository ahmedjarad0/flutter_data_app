import 'package:database/database/db_controller.dart';
import 'package:database/models/response_process.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/user.dart';
import '../../pref/shared_pref.dart';

class UserDbController {
  final Database _database = DbController().database;

  Future<ProcessResponses> login(
      {required String email, required String password}) async {
    List<Map<String, dynamic>> rowsMap = await _database.query(User.tableName,
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (rowsMap.isNotEmpty) {
      User user = User.fromMap(rowsMap.first);
      SharedPerfController().save(user: user);

      return ProcessResponses(message: 'Login Successfully', success: true);
    }
    return ProcessResponses(message: 'Credential error,check and try again ');
  }

  Future<ProcessResponses> register({required User user}) async {
    if (await _isExistEmail(email: user.email)) {
      int newRowsId = await _database.rawInsert(
          'INSERT INTO users(name,email,password) VALUES(?,?,?)',
          [user.name, user.email, user.password]);
      return ProcessResponses(
          message: newRowsId != 0 ? 'Register Successfully' : 'Register failed',
          success: newRowsId != 0);
    } else {
      return ProcessResponses(message: 'Email exist ,user another');
    }
  }

  Future<bool> _isExistEmail({required String email}) async {
    List<Map<String, dynamic>> rowsMap =
        await _database.rawQuery('SELECT * FROM users WHERE email = ?', [email]);
    return rowsMap.isEmpty;
  }
}
