import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/services/auth.dart';
import 'package:intl/intl.dart';

class Invertory extends StatefulWidget {
  const Invertory({Key? key}) : super(key: key);

  @override
  State<Invertory> createState() => _InvertoryState();
}

class _InvertoryState extends State<Invertory> {
  final formatCurrency = new NumberFormat.simpleCurrency();

  double? value;

  getValueAndPass(var mean) {
    print(mean);
    return mean;
  }

  @override
  void initState() {
    super.initState();
  }

  bool tap = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Inventory')),
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Cart').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              double value = 0.0;
              double total = 0.0;
              double mean = 0.0;
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 15.0),
                      Text("Loading....."),
                    ],
                  ),
                );
              else if (snapshot.connectionState == ConnectionState.active) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Client Email",
                            style: TextStyle(fontSize: 8.0),
                          ),
                          Text(
                            "Client UID",
                            style: TextStyle(fontSize: 8.0),
                          ),
                          Text(
                            "Product Name",
                            style: TextStyle(fontSize: 8.0),
                          ),
                          Text(
                            "Amount",
                            style: TextStyle(fontSize: 8.0),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            DocumentSnapshot point = snapshot.data!.docs[index];

                            double myPrices = double.parse(
                              point['Price'].toString().replaceAll(",", ""),
                            );
                            int myQuantity = int.parse(
                              point['Quantity'].toString().replaceAll(",", ""),
                            );

                            value = myPrices * myQuantity;

                            total += value;

                            mean = total;
                            getValueAndPass(mean);
                            print('total: $mean');
                            return SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        '\$' + '$mean',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: size.height * 0.20),
                                          child: SelectableText(
                                            '${point['Client email']}',
                                            style: TextStyle(fontSize: 8.0),
                                          ),
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: size.height * 0.15),
                                          child: SelectableText(
                                            '${point['Uid']}',
                                            style: TextStyle(fontSize: 8.0),
                                          ),
                                        ),
                                        Text(
                                          '${point['product name']}',
                                          style: TextStyle(fontSize: 8.0),
                                        ),
                                        Text(
                                          '${formatCurrency.format(myPrices)}',
                                          style: TextStyle(fontSize: 8.0),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "x",
                                              style: TextStyle(fontSize: 8.0),
                                            ),
                                            Text(
                                              myQuantity.toString(),
                                              style: TextStyle(fontSize: 8.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Container(
                    //     child: Column(
                    //   children: [
                    //     IconButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             value = getValueAndPass(mean);
                    //             print('my value is: $value');
                    //           });
                    //         },
                    //         icon: Icon(Icons.refresh)),
                    //     Text(value.toString()),
                    //   ],
                    // )

                    //     // Text(
                    //     //   total.toString(),
                    //     //   // mean.toString(),
                    //     //   //'${formatCurrency.format(mean)}',
                    //     //   style: TextStyle(
                    //     //       fontWeight: FontWeight.bold, fontSize: 16.0),
                    //     // ),
                    //     ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                );
              }
              return Center(
                child: Text("Data not available \n Error Occured"),
              );
            },
          );
        },
      ),
    );
  }
}
