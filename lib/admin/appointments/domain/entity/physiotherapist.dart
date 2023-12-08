class Physiotherapist {
  String? name;
  String? id;
  String? email;
  String? phone;
  String? speciality;
  String? imgUrl;
  String? about;

  Physiotherapist(
      {this.name,
      this.id,
      this.email,
      this.phone,
      this.speciality,
      this.imgUrl,
      this.about});

  Physiotherapist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    speciality = json['speciality'];
    imgUrl = json['imgUrl'] ?? "";
    about = json['about'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['speciality'] = this.speciality;
    data['imgUrl'] = this.imgUrl;
    data['about'] = this.about;
    return data;
  }
}
