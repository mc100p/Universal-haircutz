import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.name,
    required this.email,
    required this.img,
  });

  String name;
  String email;
  String img;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        img: json["imgUrl"],
        name: json["FullName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "name": name,
        "email": email,
      };
}
