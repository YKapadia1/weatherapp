import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weatherapp/entry_table_model.dart';

class AllCitiesDatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'userCities.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE userCities(id INTEGER PRIMARY KEY AUTOINCREMENT, cityName TEXT NOT NULL,stateName TEXT NOT NULL, countryName TEXT NOT NULL, isFavourite INTEGER NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertUserCity(List<Entry> userCitySelection) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var cityName in userCitySelection) {
      result = await db.insert('userCities', cityName.toMap());
    }
    return result;
  }

  Future<List<Entry>> getUserCities() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('userCities');
    return queryResult.map((e) => Entry.fromMap(e)).toList();
  }

  Future<void> deleteUserCity(int id) async {
    final db = await initializeDB();
    await db.delete(
      'userCities',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
