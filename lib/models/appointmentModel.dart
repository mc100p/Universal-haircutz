import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

AppointmentModel appointmentModelFromJson(String str) =>
    AppointmentModel.fromJson(json.decode(str));

String appointmentDataToJson(AppointmentModel data) =>
    json.encode(data.toJson());

class AppointmentModel {
  AppointmentModel({
    required this.barbersName,
    required this.dateMade,
    required this.ends,
    required this.reservedBy,
    required this.starting,
    required this.task,
    required this.completed,
    required this.compoundKey,
  });

  String? barbersName;
  Timestamp? dateMade;
  Timestamp? ends;
  String? reservedBy;
  Timestamp? starting;
  String? task;
  String? completed;
  String? compoundKey;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        barbersName: json['barbers name'],
        dateMade: json['dateMade'],
        ends: json['ends'],
        reservedBy: json['reserved by'],
        starting: json['starting'],
        task: json['task'],
        completed: json['completed'].toString(),
        compoundKey: json['compoundKey'],
      );

  Map<String, dynamic> toJson() => {
        "barbers name": barbersName,
        "date made": dateMade,
        "ends": ends,
        "reservedBy": reservedBy,
        "starting": starting,
        "task": task,
        "completed": completed,
        "compoundKey": compoundKey,
      };
}
