class UserCityDetails 
{
  final int? id;
  final String? cityName;
  final String? stateName;
  final String? countryName;
  late int isFavourite;
  //The member variables that will store the user's selection.

  UserCityDetails(
    {
    this.id,
    required this.cityName,
    required this.stateName,
    required this.countryName,
    required this.isFavourite,
    });

  UserCityDetails.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        cityName = res['cityName'],
        stateName = res['stateName'],
        countryName = res['countryName'],
        isFavourite = res['isFavourite'];
        //Get the details from the data model map.

  Map<String, Object?> toMap() 
  {
    return 
    {
      'id': id,
      'cityName': cityName,
      'stateName': stateName,
      'countryName': countryName,
      'isFavourite': isFavourite
      //Convert the list to a Map type, if requested.
    };
  }
}
