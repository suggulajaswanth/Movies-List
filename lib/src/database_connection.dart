import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationSupportDirectory();
    var path = join(directory.path, 'db_movielist');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE movies(id INTEGER PRIMARY KEY, mname TEXT, mdirector TEXT, imagepath TEXT)");
  }
}
