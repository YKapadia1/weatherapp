class test {
  String? status;
  List<States>? data;

  test({this.status, this.data});

  test.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <States>[];
      json['data'].forEach((v) {
        data!.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  String? state;

  States({this.state});

  States.fromJson(Map<String, dynamic> json) {
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    return data;
  }
}

class Cities {
  String? city;

  Cities({this.city});

  Cities.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    return data;
  }
}
