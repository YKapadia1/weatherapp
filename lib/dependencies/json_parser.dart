class States //The data model used to temporarily store the list of states returned by the weather API.
{
  String? state;

  States({this.state});

  States.fromJson(Map<String, dynamic> json) 
  {
    state = json['state'];
  }
}

class Cities //The data model used to temporarily store the list of cities returned by the weather API.
{
  String? city;

  Cities({this.city});

  Cities.fromJson(Map<String, dynamic> json) 
  {
    city = json['city'];
  }
}
