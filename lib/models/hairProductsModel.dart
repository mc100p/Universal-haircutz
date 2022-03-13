import 'dart:convert';

HairProductsData hairProductsDataFromJson(String str) =>
    HairProductsData.fromJson(json.decode(str));

String hairProductsDataToJson(HairProductsData data) =>
    json.encode(data.toJson());

class HairProductsData {
  HairProductsData({
    required this.img,
    required this.productName,
    required this.price,
    required this.uses,
    required this.warnings,
    required this.directions,
    required this.inactiveIngredients,
  });

  String img;
  String productName;
  String price;
  List<dynamic> uses;
  List<dynamic> warnings;
  List<dynamic> directions;
  String inactiveIngredients;

  factory HairProductsData.fromJson(Map<String, dynamic> json) =>
      HairProductsData(
        img: json["img"],
        productName: json["productName"],
        price: json["price"],
        uses: json["Uses"],
        warnings: json["Warnings"],
        directions: json["Directions"],
        inactiveIngredients: json["Inactive_ingredients"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "productName": productName,
        "price": price,
        "uses": uses,
        "warnings": warnings,
        "directions": directions,
        "inactiveIngredients": inactiveIngredients,
      };
}
