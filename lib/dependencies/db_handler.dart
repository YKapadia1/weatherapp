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

  //This function is called whenever the user adds a new city to their list. It inserts the list into the database as a new column.
  Future<int> insertUserCity(List<UserCityDetails> userCitySelection) async 
  {
    int result = 0;
    final Database db = await initializeDB(); //Initialise and open the database.
    for (var cityName in userCitySelection) //For each city the user wants adding... (always 1)
    {
      result = await db.insert('userCities', cityName.toMap()); //Insert the data as a new row into the database.
    }
    return result;
  }

  //This function is called whenever the user sets or unsets a city as their favourite.
  Future<int> setFavCity(UserCityDetails userCitySelection, int newFavValue) async 
  {
    int result = 0;
    userCitySelection.isFavourite = newFavValue; //Update the data entry to be the new value the user wants.
    final Database db = await initializeDB();
    result = await db.update('userCities', userCitySelection.toMap(), where: 'id = ?', whereArgs: [userCitySelection.id]);
    //This updates the entry row of the city the user wants (un)favouriting only.
    //It's easier to update the entire row even though one value changes.
    return result;
  }

  Future<List<UserCityDetails>> getUserCities() async 
  //This function is called to get the list of cities a user may already have added.
  //This function can also return nothing, in which case a message will display on screen telling the user what to do.
  {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('userCities');
    //Get the list of any rows in the database, and store it in a list of maps to return to the function caller.
    return queryResult.map((e) => UserCityDetails.fromMap(e)).toList();
  }

  //This function is called to get the list of cities a user has favourited.
  //This function can also return nothing, in which case a message will display on screen telling the user what to do.
  Future<List<UserCityDetails>> getFavUserCities() async 
  {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('userCities', where: "isFavourite = ?", whereArgs: [1]);
    return queryResult.map((e) => UserCityDetails.fromMap(e)).toList();
  }

  //This function is called whenever a user wants to delete a city from the database. 
  //Note that this does not prevent the user from adding that same city in the future.
  Future<void> deleteUserCity(int id) async 
  {
    final db = await initializeDB();
    await db.delete('userCities', where: "id = ?", whereArgs: [id],);
    //Delete the specified row the user wants removing.
  }
}
