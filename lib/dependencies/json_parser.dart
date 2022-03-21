class Countries 
{
  String? status;
  List<States>? data;

  Countries({this.status, this.data});

  Countries.fromJson(Map<String, dynamic> json) 
  {
    status = json['status'];
    if (json['data'] != null) 
    {
      data = <States>[];
      json['data'].forEach((v) 
      {
        data!.add( States.fromJson(v));
      });
    }
  }

  
  Map<String, dynamic> toJson() 
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) 
    {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
