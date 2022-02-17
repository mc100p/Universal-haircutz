import 'dart:convert';

HairCareModel hairCareModelFromJson(String str) =>
    HairCareModel.fromJson(json.decode(str));

String hairCareModelToJson(HairCareModel data) => json.encode(data.toJson());

class HairCareModel {
  HairCareModel({
    required this.name,
    required this.img,
    required this.cost,
  });

  String name;
  String img;
  String cost;

  factory HairCareModel.fromJson(Map<String, dynamic> json) => HairCareModel(
        img: json["imgUrl"],
        name: json["name"],
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "name": name,
        "cost": cost,
      };
}
