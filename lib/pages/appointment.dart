import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/models/userModel.dart';
import 'package:universalhaircutz/pages/appointmentFolder/appointmentDetails.dart';

class AppointmentDetails extends StatefulWidget {
  final heroTag;
  final cost;
  final name;
  final tasks;

  const AppointmentDetails(
      {Key? key, this.heroTag, this.cost, this.name, this.tasks})
      : super(key: key);

  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Barbers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            Center(child: CircularProgressIndicator());
          else if (snapshot.connectionState == ConnectionState.active) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Select a barber'),
                actions: [
                  IconButton(
                    onPressed: () => showSearch(
                      context: context,
                      delegate: BarberSearchList(
                        snapshot.data!.docs,
                        "Barbers",
                        this.widget.heroTag,
                        this.widget.name,
                        this.widget.cost,
                        this.widget.tasks,
                      ),
                    ),
                    icon: Icon(Icons.search),
                  )
                ],
              ),
              body: ListView.builder(
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
                          tasks: this.widget.tasks,
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
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Icon(
                                                  Icons.broken_image_outlined),
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
                                            user.name,
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
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class BarberSearchList extends SearchDelegate {
  final documents;
  final collection;
  final heroTag;
  final clientName;
  final price;
  final tasks;

  BarberSearchList(this.documents, this.collection, this.heroTag,
      this.clientName, this.price, this.tasks);

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: Icon(Icons.clear))
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collection).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final results = snapshot.data!.docs.where((DocumentSnapshot a) =>
              a['FullName']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()));

          return ListView(
              children: results
                  .map<Widget>(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15.0),
                      child: SizedBox(
                        height: size.height * 0.15,
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/appointmentDetails',
                                arguments: AppointmentSetUp(
                                  heroTag: this.heroTag,
                                  name: this.clientName,
                                  price: this.price,
                                  barberName: a['FullName'],
                                  barberEmail: a['email'],
                                  barberImage: a['imgUrl'],
                                  tasks: this.tasks,
                                ),
                              );
                            },
                            leading: SizedBox(
                              height: size.height * 0.12,
                              width: size.width * 0.14,
                              child: ClipOval(
                                child: Image(
                                  image: NetworkImage(
                                    a['imgUrl'],
                                  ),
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : CircularProgressIndicator();
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Icon(Icons.broken_image_outlined),
                                    );
                                  },
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['FullName'].toString()),
                                Text('${a['email'].toString()}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList());
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));
}
