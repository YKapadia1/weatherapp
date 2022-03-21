import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weatherapp/user_city_table_model.dart';

class DatabaseHandler 
{
  Future<Database> initializeDB() async //This opens the database so information inside can be queried and displayed in the app.
  //The database is created automatically if it does not exist.
  {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'userCities.db'),
      onCreate: (database, version) async
      //Create a database called userCities with the columns specified.
      {
        await database.execute("CREATE TABLE userCities(id INTEGER PRIMARY KEY AUTOINCREMENT, cityName TEXT NOT NULL,stateName TEXT NOT NULL, countryName TEXT NOT NULL, isFavourite INTEGER NOT NULL)",);
      },
      version: 1,
    );
  }

  Future<int> insertUserCity(List<UserCityDetails> userCitySelection) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var cityName in userCitySelection) 
    {
      result = await db.insert('userCities', cityName.toMap());
    }
    return result;
  }

  Future<int> setFavCity(UserCityDetails userCitySelection, int newFavValue) async {
    int result = 0;
    userCitySelection.isFavourite = newFavValue;
    final Database db = await initializeDB();
    result = await db.update('userCities', userCitySelection.toMap(), where: 'id = ?', whereArgs: [userCitySelection.id]);
    return result;
  }

  Future<List<UserCityDetails>> getUserCities() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('userCities');
    return queryResult.map((e) => UserCityDetails.fromMap(e)).toList();
  }

  Future<List<UserCityDetails>> getFavUserCities() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('userCities', where: "isFavourite = ?", whereArgs: [1]);
    return queryResult.map((e) => UserCityDetails.fromMap(e)).toList();
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
