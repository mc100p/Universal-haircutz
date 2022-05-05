import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:universalhaircutz/services/auth.dart';

class AppointmentSetUp extends StatefulWidget {
  final heroTag;
  final name;
  final price;
  final barberName;
  final barberEmail;
  final barberImage;
  final tasks;

  const AppointmentSetUp(
      {Key? key,
      this.heroTag,
      this.name,
      this.price,
      this.barberName,
      this.barberEmail,
      this.barberImage,
      this.tasks})
      : super(key: key);
  @override
  State<AppointmentSetUp> createState() => _AppointmentSetUpState();
}

class _AppointmentSetUpState extends State<AppointmentSetUp>
    with SingleTickerProviderStateMixin {
  final format = DateFormat("yyyy-MM-dd - hh:mm ");

  DateTime? appointmentTime;

  bool noData = false;

  int savedCount = 0;

  final initialValue = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TabController tabController;

  bool button = false;

  bool purchasePossible = false;

  bool isloading = false;

  MeetingDataSource? events;

  String deviceToken = '';

  get getToken async {
    final token = await FirebaseMessaging.instance.getToken();
    print('token: ' + token!);
    setState(() {
      deviceToken = token;
    });
    return token;
  }

  isPurchasePossible() async {
    var uid = await getCurrentUID();
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection("Allergies").doc(uid).get();
    if (mounted)
      setState(() {
        purchasePossible = ds.exists;
      });
    if (purchasePossible == true) {
      print('purchase possible');
    } else {
      print('purchase not possible');
    }
  }

  @override
  void initState() {
    super.initState();
    isPurchasePossible();
    tabController = new TabController(length: 2, vsync: this);
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {
          isloading = false;
        });
      });
    });
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("Appointments")
        .where("barbers name", isEqualTo: this.widget.barberName)
        .where("task", isEqualTo: this.widget.tasks)
        .where("reserved by", isEqualTo: "")
        .get();

    if (snapShotsValue.docs.isEmpty) {
      setState(() {
        noData = true;
      });
    }

    List<Meeting> list = snapShotsValue.docs.map((e) {
      print("Start time: ${e.data()['starting'].toDate()}");
      print("End time: ${e.data()['ends'].toDate()}");

      DateTime starting = e.data()['starting'].toDate();

      DateTime ending = e.data()['ends'].toDate();
      return Meeting(
          eventName: "${e.data()['task']}",
          from: starting,
          to: ending,
          background: Theme.of(context).primaryColor,
          isAllDay: false);
    }).toList();
    setState(() {
      events = MeetingDataSource(list);
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(child: CircularProgressIndicator())
        : noData
            ? Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Text("No reservations avaliable"),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text('${this.widget.barberName}'),
                ),
                body: SfCalendar(
                  view: CalendarView.month,
                  dataSource: events,
                  onTap: calendarTapped,
                  onSelectionChanged: (details) {},
                  monthViewSettings: const MonthViewSettings(
                      showAgenda: true,
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment),
                ),
              );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting _meeting = details.appointments![0];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Appointment details'),
            content: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Service: ${_meeting.eventName!}'),
                Row(
                  children: [
                    Text(
                        'Start: ${DateFormat.yMMMMd().format(_meeting.from!)}'),
                    Text(" @"),
                    Text(' ${DateFormat('kk:mm').format(_meeting.from!)}')
                  ],
                ),
                Row(
                  children: [
                    Text('Ends: ${DateFormat.yMMMMd().format(_meeting.to)}'),
                    Text(" @"),
                    Text(' ${DateFormat('kk:mm').format(_meeting.to)}')
                  ],
                ),
              ],
            )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  String? fullName =
                      FirebaseAuth.instance.currentUser!.displayName;
                  String? email = FirebaseAuth.instance.currentUser!.email;
                  var reservationObject = {
                    "barbersName": this.widget.barberName,
                    "client Name": fullName,
                    "email": email,
                    "startTime": _meeting.from,
                    "endTime": _meeting.to,
                    "uid": uid,
                    "cost": this.widget.price,
                    "reservation description": _meeting.eventName,
                    "client token": deviceToken,
                    "compoundKey": this.widget.barberName +
                        _meeting.from.toString().trim(),
                    "completed": false,
                  };

                  FirebaseFirestore.instance
                      .collection("Appointments")
                      .doc(this.widget.barberName +
                          _meeting.from.toString().trim())
                      .update({"reserved by": fullName, "Email": email}).then(
                          (value) {
                    Fluttertoast.showToast(
                      msg: "Your appointment date has been saved",
                    );
                  }).timeout(Duration(minutes: 2), onTimeout: () {
                    setState(() {
                      isloading = false;
                      _showDialog2();
                      print("error");
                    });
                  });

                  FirebaseFirestore.instance
                      .collection("Reserved Appointments")
                      .doc(this.widget.barberName +
                          _meeting.from.toString().trim())
                      .set(reservationObject)
                      .then((value) {
                    Fluttertoast.showToast(
                      msg: "Your appointment date has been saved",
                    );
                    Navigator.pop(context);
                  }).timeout(Duration(minutes: 2), onTimeout: () {
                    setState(() {
                      isloading = false;
                      _showDialog2();
                      print("error");
                    });
                  });
                  getDataFromFireStore();
                },
                child: Text("Reserve Time"),
              )
            ],
          );
        },
      );
    }
  }

  void _showDialog2() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Appointment Date Saved"),
          content: Wrap(
            children: [
              Text("Network Connection is not stable, your appointment"
                  " will still be saved when you reconnect to a stable"
                  " network connection")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime to;
  Color? background;
  bool? isAllDay;

  Meeting(
      {this.eventName,
      this.from,
      required this.to,
      this.background,
      this.isAllDay});
}
