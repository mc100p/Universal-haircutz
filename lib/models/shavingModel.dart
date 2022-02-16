import 'dart:convert';

ShavingModel shavingModelFromJson(String str) =>
    ShavingModel.fromJson(json.decode(str));

String shavingModelToJson(ShavingModel data) => json.encode(data.toJson());

class ShavingModel {
  ShavingModel({
    required this.name,
    required this.img,
    required this.cost,
  });

  String name;
  String img;
  String cost;

  factory ShavingModel.fromJson(Map<String, dynamic> json) => ShavingModel(
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
