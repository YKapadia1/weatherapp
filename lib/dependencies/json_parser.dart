class States 
{
  String? state;

  States({this.state});

  States.fromJson(Map<String, dynamic> json) 
  {
    state = json['state'];
  }

  Map<String, dynamic> toJson() 
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    return data;
  }
}

class Cities {
  String? city;

  Cities({this.city});

  Cities.fromJson(Map<String, dynamic> json) 
  {
    city = json['city'];
  }

  Map<String, dynamic> toJson() 
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    return data;
  }
}
