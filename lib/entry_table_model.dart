class Entry {
  final int? id;
  final String? cityName;
  final String? stateName;
  final String? countryName;
  final int isFavourite;

  const Entry({
    this.id,
    required this.cityName,
    required this.stateName,
    required this.countryName,
    required this.isFavourite,
  });

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  Entry.fromMap(Map<String, dynamic> res)
      : id = res['id'],
      cityName = res['cityName'],
        stateName = res['stateName'],
        countryName = res['countryName'],
        isFavourite = res['isFavourite'];

  Map<String, Object?> toMap() {
    return {
      'id':id,
      'cityName': cityName,
      'stateName': stateName,
      'countryName': countryName,
      'isFavourite': isFavourite
    };
  }
}
