import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:universalhaircutz/adminPanel/adminReservation/reservationUtilities.dart';
import 'package:universalhaircutz/models/appointmentModel.dart';
import 'package:universalhaircutz/services/auth.dart';

String collection = 'Appointments';

class Appointments extends StatefulWidget {
  final TabController tabController;
  final String barbersName;

  const Appointments({
    Key? key,
    required this.tabController,
    required this.barbersName,
  }) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  String selectTask = "Shaving";
  List<String> items = ["Hair Care", "Hair Style", "Shaving"];
  DateTime commence = DateTime.now();
  DateTime? ends;
  int savedCount1 = 0;
  int savedCount2 = 0;
  final initialValue = DateTime.now();
  final format = DateFormat("MMM dd, yyyy - h:mm ");
  bool isloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection(collection).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Expanded(child: Text("No Reservations have been made")),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        width: size.width * 0.80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: FloatingActionButton(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            onPressed: () => showDialog(
                                context: context,
                                builder: (builder) {
                                  return ReservationDetails();
                                }),
                            child: Text(
                              "Create Reservation",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 5,
                      child: ReservationList(documents: snapshot.data!.docs)),
                  Expanded(
                      child: SizedBox(
                    width: size.width * 0.80,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        onPressed: () => showDialog(
                            context: context,
                            builder: (builder) {
                              return ReservationDetails();
                            }),
                        child: Text(
                          "Create Reservation",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ReservationList extends StatefulWidget {
  final List<DocumentSnapshot>? documents;
  const ReservationList({Key? key, this.documents}) : super(key: key);

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collection)
              .orderBy("dateMade")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot keyword = snapshot.data!.docs[index];
                  AppointmentModel appointmentModel = AppointmentModel.fromJson(
                      keyword.data() as Map<String, dynamic>);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 35.0),
                    child: ListTile(
                      tileColor: Theme.of(context).cardColor,
                      onTap: () => showDialog(
                          context: context,
                          builder: (builder) {
                            return ReservationDetails(
                              document: this.widget.documents![index],
                            );
                          }),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Details'),
                          if (appointmentModel.reservedBy != "" &&
                              appointmentModel.completed == 'false') ...[
                            Text(
                              "Reserved",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 10.0),
                            ),
                          ] else
                            Container(),
                          if (appointmentModel.completed == 'true') ...[
                            Container(
                                color: Colors.green,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ))
                          ],
                          if (appointmentModel.reservedBy == null) ...[
                            Container(),
                          ]
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  "Starting: ${DateFormat.yMMMEd().format(appointmentModel.starting!.toDate())}"),
                              Text(
                                  " @ ${DateFormat('kk:mm').format(appointmentModel.starting!.toDate())}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                  "Ends: ${DateFormat.yMMMEd().format(appointmentModel.ends!.toDate())}"),
                              Text(
                                  " @ ${DateFormat('kk:mm').format(appointmentModel.ends!.toDate())}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ReservationDetails extends StatefulWidget {
  final DocumentSnapshot? document;

  const ReservationDetails({Key? key, this.document}) : super(key: key);

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  bool isloading = false;

  DateTime startDate = DateTime.now();
  //= DateTime.now();

  DateTime endDate = DateTime.now();
  //= DateTime.now();

  DateTime? commence;

  DateTime? ends;

  int savedCount1 = 0;

  int savedCount2 = 0;

  PageController? pageController;

  User user = FirebaseAuth.instance.currentUser!;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final format = DateFormat("MMM dd, yyyy - h:mm ");

  final initialValue = DateTime.now();

  String? selectTask;

  String taskRequired = '';

  String barbersName = '';

  String? selectedService;

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);

    getData;

    if (widget.document != null) {
      startDate = this.widget.document!['starting'].toDate();
      endDate = this.widget.document!['ends'].toDate();
      taskRequired = this.widget.document!['task'];
    }
    commence = startDate;
    ends = endDate;
    selectTask = taskRequired;
  }

  @override
  void dispose() {
    super.dispose();
    pageController?.dispose();
  }

  get getData async {
    String uid = await getCurrentUID();
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic>? fetchDoc = snapshot.data() as Map<String, dynamic>?;

      setState(() {
        barbersName = fetchDoc?['FullName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      child: Text(
        "Ok",
      ),
      onPressed: () {
        FirebaseFirestore.instance.runTransaction(
          (transaction) async {
            DocumentSnapshot snapshot =
                await transaction.get(widget.document!.reference);
            transaction.delete(snapshot.reference);
            Fluttertoast.showToast(
              msg: 'Appointment Time Deleted',
              toastLength: Toast.LENGTH_SHORT,
            );
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ).catchError((onError) {
          print("Error");
          Fluttertoast.showToast(
              msg: "Please try again or" + " connect to a stable network",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.grey[700],
              textColor: Colors.grey[50],
              gravity: ToastGravity.CENTER);
          Navigator.pop(context);
        });
      },
    );

    void deleteOptions() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Delete Appointment Date",
            ),
            content: Text(
              "Are you sure you want to " +
                  "permanently delete this Appointment Date?",
              style: TextStyle(fontSize: 12.0),
            ),
            actions: <Widget>[
              cancelButton,
              okButton,
            ],
          );
        },
      );
    }

    void saveMemo() {
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

    return StatefulBuilder(builder: (context, stateSet) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Reservation Details"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text('${DateFormat.yMMMMd().format(startDate)}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: size.width * 0.01),
                        Text('@ ${DateFormat('kk:mm').format(startDate)} ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('-',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(' ${DateFormat.yMMMMd().format(ends!)}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: size.width * 0.01),
                        Text('@ ${DateFormat('kk:mm').format(ends!)}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    selectTask == null
                        ? Container()
                        : Row(
                            children: [
                              Text(
                                "Task Required: $selectTask",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                    SizedBox(height: size.height * 0.05),
                    task("Task"),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      child: Flex(
                        direction: Axis.vertical,
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Services")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              return Column(
                                children: [
                                  SizedBox(
                                    //  width: size.width * 0.90,
                                    child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .canvasColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        hint: Text("Select a service"),
                                        items: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                          return DropdownMenuItem<String>(
                                            value: document
                                                .get("Service".toString()),
                                            child: Text(
                                                "${document.get("Service".trim())}"),
                                          );
                                        }).toList(),
                                        onChanged: (String? service) {
                                          stateSet(() {
                                            selectTask = service!;
                                          });
                                        }),
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
                task("Start"),
                SizedBox(height: size.height * 0.05),
                DateTimeField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        new Radius.circular(10.0),
                      ),
                    ),
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        initialDate: currentValue!,
                        lastDate: DateTime(2500));

                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(currentValue),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  resetIcon: null,
                  autovalidateMode: AutovalidateMode.always,
                  // ignore: unnecessary_null_comparison
                  validator: (date) =>
                      date.toString() == null ? 'Invalid date' : null,
                  initialValue: initialValue,
                  onChanged: (date) => setState(() {
                    commence = date!;
                  }),
                  onSaved: (date) => setState(
                    () {
                      commence = date!;
                      savedCount1++;
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                task("Ends"),
                SizedBox(height: size.height * 0.05),
                DateTimeField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        new Radius.circular(10.0),
                      ),
                    ),
                  ),
                  resetIcon: null,
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        initialDate: commence!,
                        lastDate: DateTime(2500));

                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            commence!.add(Duration(minutes: 5))),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  autovalidateMode: AutovalidateMode.always,
                  // ignore: unnecessary_null_comparison
                  // validator: (date) =>
                  //     date.toString() == null ? 'Invalid date' : null,
                  initialValue: commence,
                  onChanged: (date) => setState(() {
                    ends = date!;
                  }),
                  onSaved: (date) => setState(
                    () {
                      ends = date!;
                      savedCount2++;
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                isloading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          if (this.widget.document == null) ...[
                            SizedBox(
                              height: size.height * 0.08,
                              width: size.width * 0.80,
                              child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () async {
                                  Timestamp timestamp = Timestamp.now();
                                  if (commence == null || ends == null) {
                                    Fluttertoast.showToast(
                                        msg: "Enter time periods");
                                  } else
                                    try {
                                      Timestamp timestamp = Timestamp.now();
                                      setState(() {
                                        isloading = true;
                                      });
                                      var appointmentObject = {
                                        "barbers name": barbersName,
                                        "task": selectTask,
                                        "starting": commence,
                                        "ends": ends,
                                        "dateMade": timestamp,
                                        "reserved by": "",
                                        "completed": false,
                                        "compoundKey": barbersName +
                                            commence.toString().trim()
                                      };

                                      widget.document == null
                                          ? FirebaseFirestore.instance
                                              .collection("Appointments")
                                              .doc(barbersName +
                                                  commence.toString().trim())
                                              .set(appointmentObject)
                                              .then((value) {
                                              setState(() {
                                                isloading = false;
                                              });
                                              Fluttertoast.showToast(
                                                  msg: "Appointment Saved");
                                              Navigator.pop(context);
                                            })
                                          : FirebaseFirestore.instance
                                              .runTransaction(
                                                  (transaction) async {
                                              DocumentSnapshot snapshot =
                                                  await transaction.get(widget
                                                      .document!.reference);

                                              transaction.update(
                                                  snapshot.reference,
                                                  appointmentObject);
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Your appointment has been updated",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                              Navigator.pop(context);
                                            })
                                        ..catchError(
                                          (onError) {
                                            setState(
                                              () {
                                                isloading = false;
                                                Fluttertoast.showToast(
                                                    msg: "Please try again or" +
                                                        " connect to a stable network",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    backgroundColor:
                                                        Colors.grey[700],
                                                    textColor: Colors.grey[50],
                                                    gravity:
                                                        ToastGravity.CENTER);
                                              },
                                            );
                                          },
                                        );
                                    } catch (e) {
                                      if (mounted)
                                        setState(
                                          () {
                                            isloading = false;
                                          },
                                        );
                                      print(e);
                                    }
                                },
                                child: Text(
                                  "Save Appointment",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                          if (this.widget.document != null) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: size.height * 0.08,
                                  width: size.width * 0.30,
                                  child: MaterialButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () async {
                                      Timestamp timestamp = Timestamp.now();
                                      if (commence == null || ends == null) {
                                        Fluttertoast.showToast(
                                            msg: "Enter time periods");
                                      } else
                                        try {
                                          Timestamp timestamp = Timestamp.now();
                                          setState(() {
                                            isloading = true;
                                          });
                                          var appointmentObject = {
                                            "barbers name": barbersName,
                                            "task": selectTask,
                                            "starting": commence,
                                            "ends": ends,
                                            "dateMade": timestamp,
                                            "reserved by": "",
                                            "completed": false,
                                            "compoundKey": barbersName +
                                                commence.toString().trim()
                                          };

                                          widget.document == null
                                              ? FirebaseFirestore.instance
                                                  .collection("Appointments")
                                                  .add(appointmentObject)
                                                  .then((value) {
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg: "Appointment Saved");
                                                  Navigator.pop(context);
                                                })
                                              : FirebaseFirestore.instance
                                                  .runTransaction(
                                                      (transaction) async {
                                                  DocumentSnapshot snapshot =
                                                      await transaction.get(
                                                          widget.document!
                                                              .reference);

                                                  transaction.update(
                                                      snapshot.reference,
                                                      appointmentObject);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Your appointment has been updated",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT);
                                                  Navigator.pop(context);
                                                })
                                            ..catchError(
                                              (onError) {
                                                setState(
                                                  () {
                                                    isloading = false;
                                                    Fluttertoast.showToast(
                                                        msg: "Please try again or" +
                                                            " connect to a stable network",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        backgroundColor:
                                                            Colors.grey[700],
                                                        textColor:
                                                            Colors.grey[50],
                                                        gravity: ToastGravity
                                                            .CENTER);
                                                  },
                                                );
                                              },
                                            );
                                        } catch (e) {
                                          if (mounted)
                                            setState(
                                              () {
                                                isloading = false;
                                              },
                                            );
                                          print(e);
                                        }
                                    },
                                    child: Text(
                                      "Save Appointment",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 20.0),
                                // ),
                                SizedBox(
                                  height: size.height * 0.08,
                                  width: size.width * 0.30,
                                  child: MaterialButton(
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      'Delete Appointment',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      deleteOptions();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
