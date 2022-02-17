import 'dart:convert';

HairWarmingModel hairWarmingModelFromJson(String str) =>
    HairWarmingModel.fromJson(json.decode(str));

String hairWarmingModelToJson(HairWarmingModel data) =>
    json.encode(data.toJson());

class HairWarmingModel {
  HairWarmingModel({
    required this.name,
    required this.img,
    required this.cost,
  });

  String name;
  String img;
  String cost;

  factory HairWarmingModel.fromJson(Map<String, dynamic> json) =>
      HairWarmingModel(
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
