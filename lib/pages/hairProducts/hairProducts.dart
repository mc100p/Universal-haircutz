import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/models/hairProductsModel.dart';
import 'package:universalhaircutz/pages/hairProducts/hairProdDetails.dart';
import 'package:universalhaircutz/pages/hairProducts/hairProductsSearch.dart';
import 'package:universalhaircutz/services/auth.dart';
import 'package:universalhaircutz/utils/searcher.dart';

class HairProducts extends StatefulWidget {
  const HairProducts({Key? key}) : super(key: key);

  @override
  _HairProductsState createState() => _HairProductsState();
}

class _HairProductsState extends State<HairProducts> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('HairProducts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            Center(child: CircularProgressIndicator());
          if (snapshot.connectionState == ConnectionState.active) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
              ),
              appBar: AppBar(
                title: Text('Hair Products'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => showSearch(
                        context: context,
                        delegate: HairProductSearch(
                            snapshot.data!.docs, "HairProducts")),
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot keyword = snapshot.data!.docs[index];
                  HairProductsData hairProducts = HairProductsData.fromJson(
                      keyword.data()! as Map<String, dynamic>);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/hairProductDetails',
                        arguments: HairProductsDetails(
                          heroTag: hairProducts.img,
                          name: hairProducts.productName,
                          price: hairProducts.price,
                          uses: hairProducts.uses,
                          warnings: hairProducts.warnings,
                          directions: hairProducts.directions,
                          inactiveIngredients: hairProducts.inactiveIngredients,
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
                                        tag: hairProducts.img,
                                        child: Image(
                                          image: NetworkImage(
                                            hairProducts.img,
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
                                            hairProducts.productName,
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
                                            '\$${hairProducts.price}',
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
