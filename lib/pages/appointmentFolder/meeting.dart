// import 'package:flutter/material.dart';

// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }

//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].from;
//   }

//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to;
//   }

//   @override
//   bool isAllDay(int index) {
//     return appointments![index].isAllDay;
//   }

//   @override
//   String getSubject(int index) {
//     return appointments![index].eventName;
//   }

//   @override
//   Color getColor(int index) {
//     return appointments![index].background;
//   }
// }

// class Meeting {
//   String? eventName;
//   DateTime? from;
//   DateTime? to;
//   Color? background;
//   bool? isAllDay;

//   Meeting({this.eventName, this.from, this.to, this.background, this.isAllDay});
// }
