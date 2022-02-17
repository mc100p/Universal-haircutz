import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/models/hairWarmmingModel.dart';
import 'package:universalhaircutz/pages/appointment.dart';
import 'package:universalhaircutz/services/auth.dart';

class HairWarming extends StatefulWidget {
  const HairWarming({Key? key}) : super(key: key);

  @override
  _HairWarmingState createState() => _HairWarmingState();
}

class _HairWarmingState extends State<HairWarming> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hair Warmming'),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: FutureBuilder(
          future: getCurrentUID(),
          builder: (context, snapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('HairWarming')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  Center(child: CircularProgressIndicator());
                else if (snapshot.connectionState == ConnectionState.active) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot keyword = snapshot.data!.docs[index];
                      HairWarmingModel hairWarming = HairWarmingModel.fromJson(
                          keyword.data()! as Map<String, dynamic>);
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/appointment',
                            arguments: AppointmentDetails(
                              heroTag: hairWarming.img,
                              name: hairWarming.name,
                              cost: hairWarming.cost,
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
                                            tag: hairWarming.img,
                                            child: Image(
                                              image: NetworkImage(
                                                hairWarming.img,
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
                                                hairWarming.name,
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
                                                '\$${hairWarming.cost}',
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
                            // IconButton(
                            //   icon: Icon(Icons.info),
                            //   onPressed: () {},
                            // ),
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
