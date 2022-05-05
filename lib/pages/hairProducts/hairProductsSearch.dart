import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/pages/appointment.dart';
import 'package:universalhaircutz/pages/hairProducts/hairProdDetails.dart';

class HairProductSearch extends SearchDelegate {
  final collection;
  final documents;
  HairProductSearch(this.documents, this.collection);
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
              a['productName']
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
                                '/hairProductDetails',
                                arguments: HairProductsDetails(
                                  heroTag: a['img'],
                                  name: a['productName'],
                                  price: a['price'],
                                  uses: a['Uses'],
                                  warnings: a['Warnings'],
                                  directions: a['Directions'],
                                  inactiveIngredients:
                                      a['Inactive_ingredients'],
                                ),
                              );
                            },
                            leading: SizedBox(
                              height: size.height * 0.12,
                              width: size.width * 0.14,
                              child: ClipOval(
                                child: Image(
                                  image: NetworkImage(
                                    a['img'],
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
                                Text(a['productName'].toString()),
                                Text('\$${a['price'].toString()}'),
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
