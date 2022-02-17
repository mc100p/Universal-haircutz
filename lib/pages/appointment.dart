import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/models/userModel.dart';
import 'package:universalhaircutz/pages/appointmentDetails.dart';
import 'package:universalhaircutz/services/auth.dart';

class AppointmentDetails extends StatefulWidget {
  final heroTag;
  final cost;
  final name;

  const AppointmentDetails({Key? key, this.heroTag, this.cost, this.name})
      : super(key: key);

  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a barber'),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: FutureBuilder(
          future: getCurrentUID(),
          builder: (context, snapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Barbers').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  Center(child: CircularProgressIndicator());
                else if (snapshot.connectionState == ConnectionState.active) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot keyword = snapshot.data!.docs[index];

                      UserModel user = UserModel.fromJson(
                          keyword.data()! as Map<String, dynamic>);
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/appointmentDetails',
                            arguments: AppointmentSetUp(
                              heroTag: this.widget.heroTag,
                              name: this.widget.name,
                              price: this.widget.cost,
                              barberName: user.name,
                              barberEmail: user.email,
                              barberImage: user.img,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 28.0, bottom: 12.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 38.0),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Hero(
                                            tag: user.img,
                                            child: Image(
                                              image: NetworkImage(
                                                user.img,
                                              ),
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                return progress == null
                                                    ? child
                                                    : CircularProgressIndicator();
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: Icon(Icons
                                                      .broken_image_outlined),
                                                );
                                              },
                                              fit: BoxFit.cover,
                                              height: 75.0,
                                              width: 75.0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                user.name,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'PlayfairDisplay',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                user.email,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'PlayfairDisplay',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }
}
