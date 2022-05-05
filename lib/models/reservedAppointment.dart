import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

ReservedTimeModel reservedTimeModelFromJson(String str) =>
    ReservedTimeModel.fromJson(json.decode(str));

String reservedTimeModelToJson(ReservedTimeModel data) =>
    json.encode(data.toJson());

class ReservedTimeModel {
  ReservedTimeModel({
    required this.barbersName,
    required this.clientName,
    required this.email,
    required this.clientToken,
    required this.ends,
    required this.starts,
    required this.task,
    required this.uid,
    required this.compoundKey,
    required this.cost,
  });

  String? barbersName;
  String? clientName;
  String? email;
  String? clientToken;
  Timestamp? ends;
  Timestamp? starts;
  String? task;
  String? uid;
  String? compoundKey;
  String? cost;

  factory ReservedTimeModel.fromJson(Map<String, dynamic> json) =>
      ReservedTimeModel(
        barbersName: json["barbersName"],
        clientName: json['client Name'],
        email: json['email'],
        ends: json['endTime'],
        starts: json['startTime'],
        task: json['reservation description'],
        clientToken: json['client token'],
        uid: json['uid'],
        compoundKey: json['compoundKey'],
        cost: json['cost'],
      );

  Map<String, dynamic> toJson() => {
        "barbers name": barbersName,
        "client Name": clientName,
        "email": email,
        "client token": clientToken,
        "endTime": ends,
        "reservation description": task,
        "startTime": starts,
        "uid": uid,
        "compoundKey": compoundKey,
        "cost": cost,
      };
}
