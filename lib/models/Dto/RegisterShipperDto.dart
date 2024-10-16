class Registershipperdto {
  String? name;
  String? imageCitizenFront;
  String? imageCitizenBack;
  String? email;
  String? phone;
  String? currentaddress;
  String? address;
  String? birthday;
  String? vehicle;
  String? licensePlate;
  String? DriverLicense;
  Registershipperdto({
    required this.name,
    required this.imageCitizenFront,
    required this.imageCitizenBack,
    required this.email,
    required this.phone,
    required this.currentaddress,
    required this.address,
    required this.birthday,
    required this.vehicle,
    required this.licensePlate,
    required this.DriverLicense,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
      data["name"] =  this.name;
      data["imageCitizenFront"] =  this.imageCitizenFront;
      data["imageCitizenBack"] =  this.imageCitizenBack;
      data["email"] =  this.email;
      data["phone"] =  this.phone;
      data["currentaddress"] =  this.currentaddress;
      data["address"] =  this.address;
      data["birthday"] =  this.birthday;
      data["vehicle"] =  this.vehicle;
      data["licensePlate"] =  this.licensePlate;
      data["DriverLicense"] =  this.DriverLicense;
    return data;
  }
}
