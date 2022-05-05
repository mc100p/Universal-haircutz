import 'package:flutter/material.dart';
import 'package:universalhaircutz/models/haircareModel.dart';
import 'package:universalhaircutz/pages/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universalhaircutz/services/auth.dart';
import 'package:universalhaircutz/utils/searcher.dart';

class HairCare extends StatefulWidget {
  const HairCare({Key? key}) : super(key: key);

  @override
  _HairCareState createState() => _HairCareState();
}

class _HairCareState extends State<HairCare> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('HairCare').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              Center(child: CircularProgressIndicator());
            else if (snapshot.connectionState == ConnectionState.active) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Hair Care'),
                  actions: [
                    IconButton(
                      onPressed: () => showSearch(
                          context: context,
                          delegate: FeedBackSearchList(
                              snapshot.data!.docs, "HairCare", "Hair Care")),
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
                body: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot keyword = snapshot.data!.docs[index];
                    HairCareModel hairCare = HairCareModel.fromJson(
                        keyword.data()! as Map<String, dynamic>);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/appointment',
                          arguments: AppointmentDetails(
                            heroTag: hairCare.img,
                            name: hairCare.name,
                            cost: hairCare.cost,
                            tasks: "Hair Care",
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 28.0, bottom: 12.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 38.0),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Hero(
                                          tag: hairCare.img,
                                          child: Image(
                                            image: NetworkImage(
                                              hairCare.img,
                                            ),
                                            loadingBuilder:
                                                (context, child, progress) {
                                              return progress == null
                                                  ? child
                                                  : CircularProgressIndicator();
                                            },
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
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
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              hairCare.name,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: 'PlayfairDisplay',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              '\$${hairCare.cost}',
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
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
