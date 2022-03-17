class Entry {
  final String? cityName;
  final String? stateName;
  final String? countryName;
  final bool isFavourite;

  const Entry({
    required this.cityName,
    required this.stateName,
    required this.countryName,
    required this.isFavourite,
  });

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  Entry.fromMap(Map<String, dynamic> res)
      : cityName = res['cityName'],
        stateName = res['stateName'],
        countryName = res['countryName'],
        isFavourite = res['isFavourite'];

  Map<String, Object?> toMap() {
    return {
      'cityName': cityName,
      'stateName': stateName,
      'countryName': countryName,
      'isFavourite': isFavourite
    };
  }
}
