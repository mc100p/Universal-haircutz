import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Row task(task) {
  return Row(
    children: [
      Text(
        task,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

class FeedBackSearchList extends SearchDelegate {
  final collection;
  final documents;
  FeedBackSearchList(this.documents, this.collection);
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collection).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final results = snapshot.data!.docs.where((DocumentSnapshot a) =>
              a['task'].toString().toLowerCase().contains(query.toLowerCase()));

          return ListView(
              children: results
                  .map<Widget>(
                    (a) => Card(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  title: Text("Delete Feed Back"),
                                  content: SingleChildScrollView(
                                    child: Text(
                                        "Are you sure you want to delete this Feed back?"),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel")),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          var collect = FirebaseFirestore
                                              .instance
                                              .collection(collection);

                                          var snapshot = await collect
                                              .where('compoundKey'.trim(),
                                                  isEqualTo:
                                                      a['compoundKey'.trim()])
                                              .get();

                                          for (var doc in snapshot.docs) {
                                            await doc.reference.delete();
                                          }
                                        },
                                        child: Text("Yes"))
                                  ],
                                );
                              });
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Task: ${a['task']}'),
                            a['reserved by'] == null
                                ? Container(
                                    color: Colors.green,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ))
                                : Container(),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                    '${DateFormat.yMMMMd().format(a['starting'].toDate())} '),
                                Text("-",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    ' ${DateFormat.yMMMMd().format(a['ends'].toDate())}'),
                              ],
                            ),
                          ],
                        ),
                        // trailing: Container(),
                      ),
                    ),
                  )
                  .toList());
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));
}
