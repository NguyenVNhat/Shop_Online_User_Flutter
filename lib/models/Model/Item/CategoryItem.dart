class Categoryitem {
  int? categoryId;
  String? categoryName;
  String? description;
  String? image;

  Categoryitem(
      {this.categoryId, this.categoryName, this.description, this.image});

  Categoryitem.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}
