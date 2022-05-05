import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:universalhaircutz/models/reservedAppointment.dart';

class ViewAppointments extends StatefulWidget {
  final List<DocumentSnapshot>? documents;
  final String barbersName;
  const ViewAppointments({
    Key? key,
    required this.barbersName,
    this.documents,
  }) : super(key: key);

  @override
  State<ViewAppointments> createState() => _ViewAppointmentsState();
}

class _ViewAppointmentsState extends State<ViewAppointments> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Reserved Appointments")
          .where("barbersName", isEqualTo: widget.barbersName)
          .where("completed", isEqualTo: false)

          // .where("reserved by", isNotEqualTo: " ")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No Appointments Available"),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot keyword = snapshot.data!.docs[index];
            ReservedTimeModel reservedTimeModel = ReservedTimeModel.fromJson(
                keyword.data() as Map<String, dynamic>);

            // if (appointmentModel.reservedBy != null) {
            //   return Container();
            // }

            print(this.widget.barbersName +
                reservedTimeModel.starts.toString().trim());

            return InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  onTap: (() => showDialog(
                      context: context,
                      builder: (builder) {
                        return AlertDialog(
                          title: Text("Task Completed"),
                          content: SingleChildScrollView(
                            child: Text(
                                "By selecting yes, you are marking this task as completed?"),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection("Appointments")
                                      .doc(reservedTimeModel.compoundKey)
                                      .update({"completed": 'true'});

                                  FirebaseFirestore.instance
                                      .collection("Reserved Appointments")
                                      .doc(reservedTimeModel.compoundKey)
                                      .update({"completed": 'true'});

                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: "Task Updated",
                                      toastLength: Toast.LENGTH_LONG);
                                },
                                child: Text("Yes"))
                          ],
                        );
                      })),
                  onLongPress: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete Reservation"),
                          content: SingleChildScrollView(
                            child: Text(
                                "By Clicking yes, you are about to permanently delete this appointment whether completed or not"),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("Appointments")
                                      .doc(reservedTimeModel.compoundKey)
                                      .update({
                                    "reserved by": "",
                                    "completed": 'false'
                                  });

                                  FirebaseFirestore.instance
                                      .collection("Reserved Appointments")
                                      .doc(reservedTimeModel.compoundKey)
                                      .delete();

                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: "Task Deleted",
                                      toastLength: Toast.LENGTH_LONG);
                                },
                                child: Text("Yes"))
                          ],
                        );
                      }),
                  tileColor: Theme.of(context).cardColor,
                  title: Text('Client: ${reservedTimeModel.clientName!}'),
                  subtitle: Row(
                    children: [
                      Row(
                        children: [
                          Text(
                              '${DateFormat.yMMMEd().format(reservedTimeModel.starts!.toDate())}'),
                          SizedBox(width: size.width * 0.01),
                          Text(
                              '${DateFormat.jm().format(reservedTimeModel.starts!.toDate()).substring(0, 5)}'),
                        ],
                      ),
                      Text("-", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: size.width * 0.01),
                      Row(
                        children: [
                          Text(
                              '${DateFormat.yMMMEd().format(reservedTimeModel.ends!.toDate())}'),
                          SizedBox(width: size.width * 0.01),
                          Text(
                              '${DateFormat.jm().format(reservedTimeModel.ends!.toDate()).substring(0, 5)}'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
