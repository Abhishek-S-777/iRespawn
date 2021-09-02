class AddressModel {
  String name;
  String phoneNumber;
  String street;
  String landmark;
  String flatNumber;
  String city;
  String state;
  String pincode;

  AddressModel(
      {this.name,
        this.phoneNumber,
        this.street,
        this.landmark,
        this.flatNumber,
        this.city,
        this.state,
        this.pincode});

  AddressModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    street = json['street'];
    landmark = json['landmark'];
    flatNumber = json['flatNumber'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['street'] = this.street;
    data['landmark'] = this.landmark;
    data['flatNumber'] = this.flatNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    return data;
  }
}
