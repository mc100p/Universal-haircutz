import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

InventoryModel inventoryModelFromJson(String str) =>
    InventoryModel.fromJson(json.decode(str));

String inventoryModelToJson(InventoryModel data) => json.encode(data.toJson());

class InventoryModel {
  InventoryModel({
    required this.userName,
    required this.uid,
    required this.price,
    required this.date,
    required this.quantity,
    required this.name,
  });
  String userName;
  String uid;
  double price;
  Timestamp date;
  int quantity;
  String name;

  InventoryModel copyWith({
    required String userName,
    required String uid,
    required double price,
    required String date,
    required int quantity,
    required String name,
  }) =>
      InventoryModel(
        userName: this.userName,
        uid: this.uid,
        price: this.price,
        date: this.date,
        quantity: this.quantity,
        name: this.name,
      );

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        userName: json["userName"],
        uid: json["uid"],
        price: double.parse(json["price"]),
        date: json["Date"],
        quantity: int.parse(json["Quantity"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "uid": uid,
        "price": price.toStringAsFixed(2),
        "Date": date,
        "Quantity": quantity.toString(),
        "name": name,
      };
}
