import 'dart:convert';

GroomingModel groomingModelFromJson(String str) =>
    GroomingModel.fromJson(json.decode(str));

String groomingModelToJson(GroomingModel data) => json.encode(data.toJson());

class GroomingModel {
  GroomingModel({
    required this.name,
    required this.img,
    required this.cost,
  });

  String name;
  String img;
  String cost;

  factory GroomingModel.fromJson(Map<String, dynamic> json) => GroomingModel(
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
