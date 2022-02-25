import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/services/auth.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Reservation extends StatefulWidget {
  final List<DocumentSnapshot>? documents;

  const Reservation({
    Key? key,
    this.documents,
  }) : super(key: key);

  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reservations')),
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, AsyncSnapshot snapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Appointments')
                // .doc(snapshot.data)
                // .collection("Appointments")
                //.where("User", isEqualTo: snapshot.data)
                //.orderBy("Appointment", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null)
                return Center(child: CircularProgressIndicator());
              return Scrollbar(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 25, 12.0, 0),
                      child: Shimmer(
                        duration: Duration(seconds: 3),
                        interval: Duration(seconds: 5),
                        color: Colors.white,
                        enabled: true,
                        direction: ShimmerDirection.fromLTRB(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1.0,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                            onTap: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return FirestoreListView(
                              //       document: this.widget.documents![index],
                              //     );
                              //   },
                              // );
                            },
                            title: Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "Appointment Details",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'PlayfairDisplay'),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Date: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily:
                                              'PlayfairDisplay  - Regular',
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        '${this.widget.documents![index]['Barber name']}',
                                        style: TextStyle(
                                          fontFamily:
                                              'PlayfairDisplay - Regular',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Doctor Selected: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily:
                                              'PlayfairDisplay  - Regular',
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      // Text(
                                      //   '${this.widget.documents![index]['Doctor']}',
                                      //   style: TextStyle(
                                      //     fontFamily:
                                      //         'PlayfairDisplay - Regular',
                                      //     fontWeight: FontWeight.w300,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
