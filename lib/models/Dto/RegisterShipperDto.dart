class Registershipperdto {
  String? name;
  String? citizenID;
  String? imageCitizenFront;
  String? imageCitizenBack;
  String? email;
  String? phone;
  String? address;
  String? birthday;
  String? vehicle;
  String? licensePlate;
  String? DriverLicense;
  Registershipperdto({
    required this.name,
    required this.citizenID,
    required this.imageCitizenFront,
    required this.imageCitizenBack,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthday,
    required this.vehicle,
    required this.licensePlate,
    required this.DriverLicense,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
      data["name"] =  this.name;
      data["citizenID"] =  this.citizenID;
      data["imageCitizenFront"] =  this.imageCitizenFront;
      data["imageCitizenBack"] =  this.imageCitizenBack;
      data["email"] =  this.email;
      data["phone"] =  this.phone;
      data["address"] =  this.address;
      data["age"] =  int.parse(this.birthday!);
      data["vehicle"] =  this.vehicle;
      data["licensePlate"] =  this.licensePlate;
      data["driverLicense"] =  this.DriverLicense;
    return data;
  }
}
