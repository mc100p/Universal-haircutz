import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universalhaircutz/services/auth.dart';

class HairProductsDetails extends StatefulWidget {
  final heroTag;
  final name;
  final price;
  final uses;
  final warnings;
  final directions;
  final inactiveIngredients;

  HairProductsDetails({
    this.heroTag,
    this.name,
    this.price,
    this.uses,
    this.warnings,
    this.directions,
    this.inactiveIngredients,
  });

  @override
  _HairProductsDetailsState createState() => _HairProductsDetailsState();
}

class _HairProductsDetailsState extends State<HairProductsDetails> {
  String? itemImage;
  String? itemName;
  String? itemPrice;
  String state = "Uncompleted";
  bool isloading = false;
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();

  String cardTitle = '';

  var num = 1;

  var selectedCard = 'INGREDIENTS';

  var email;

  bool purchasePossible = false;

  getSharedPreferenceData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString('email');
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferenceData();
    isPurchasePossible();
  }

  isPurchasePossible() async {
    var uid = await getCurrentUID();
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection("Allergies").doc(uid).get();
    if (mounted)
      setState(() {
        purchasePossible = ds.exists;
      });
    if (purchasePossible == true) {
      print('purchase possible');
    } else {
      print('purchase not possible');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        elevation: 0.0,
        title: Text(
          '${this.widget.name}',
          style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18.0,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            key: keyButton,
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 325.0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: isloading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        ),
                                      )
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: new MaterialButton(
                                          key: keyButton2,
                                          color: Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          child: new Text(
                                            "Add to Cart",
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          onPressed: purchasePossible
                                              ? () async {
                                                  var uid =
                                                      await getCurrentUID();
                                                  var date = DateTime.now();
                                                  // var productList = {
                                                  //   {
                                                  //     "Item name": widget.heroTag,
                                                  //     "product name": widget.name,
                                                  //     "Price": widget.price,
                                                  //     "Quantity": num.toString(),
                                                  //     "Progress": state,
                                                  //     "Date": date,
                                                  //   },
                                                  // };
                                                  try {
                                                    FirebaseFirestore.instance
                                                        .collection('Cart')
                                                        .add({
                                                      "Item name":
                                                          widget.heroTag,
                                                      "product name":
                                                          widget.name,
                                                      "Price": widget.price,
                                                      "Quantity":
                                                          num.toString(),
                                                      "Progress": state,
                                                      "Uid": uid,
                                                      "Client email": email,
                                                      "Date": date,
                                                    }).then((value) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Item added to cart",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          backgroundColor:
                                                              Colors.grey[700],
                                                          textColor:
                                                              Colors.white);

                                                      Navigator.pop(context);
                                                    }).timeout(
                                                            Duration(
                                                                seconds: 5),
                                                            onTimeout: () {
                                                      setState(() {
                                                        print("Error");
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Item will be added to the cart automatically"
                                                                " when reconnected to a stable network connection",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[700],
                                                            textColor:
                                                                Colors.white);
                                                      });
                                                    });
                                                  } on TimeoutException catch (e) {
                                                    print(e);
                                                  }
                                                }
                                              : () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (builder) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'No Allergies Provided'),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Text(
                                                                'An allergy report must be provided before any products can be purchased'),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator
                                                                    .popAndPushNamed(
                                                                        context,
                                                                        '/allergies');
                                                              },
                                                              child: Text(
                                                                  'Provide Report'),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                        ),
                                      ),
                              ),
                              SizedBox(height: 20.0),
                              Center(
                                child: Text(
                                  "Details".toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'PlayfairDisplay',
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                                endIndent: 50.0,
                                indent: 50.0,
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35.0),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Text(
                                              widget.name,
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                '\$${widget.price}',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily:
                                                      'PlayfairDisplay - Regular',
                                                ),
                                              ),
                                              Container(
                                                height: 25.0,
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                              Container(
                                                width: 125.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            17.0),
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(
                                                            () {
                                                              if (num > 1) {
                                                                num--;
                                                              }
                                                            },
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(),
                                                          child: Container(
                                                            height: 25.0,
                                                            width: 25.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7.0),
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                                size: 25.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        num.toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (num < 10) {
                                                              num++;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 30.0,
                                                          width: 30.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7.0),
                                                            color: Colors.white,
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.add,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 15.0,
                                                              key: keyButton1,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 40.0),
                                      ]),
                                    ),

                                    //Card which contains the blue Drug facts....
                                    Center(
                                      child: Card(
                                        elevation: 100.0,
                                        child: InkWell(
                                          onTap: () {
                                            selectCard(cardTitle);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                              style: BorderStyle.solid,
                                              width: 0.75,
                                            )),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                10,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0, left: 15.0),
                                                  child: Text(
                                                    "Drug Facts",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'PlayfairDisplay - Regular',
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  indent: 50.0,
                                                  endIndent: 50.0,
                                                  color: Colors.black,
                                                  thickness: 1,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0,
                                                          bottom: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "1. Inactive Ingredients: ",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontFamily:
                                                                  'PlayfairDisplay - Regular',
                                                            ),
                                                          ),
                                                          ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  210,
                                                            ),
                                                            child: Text(
                                                              widget
                                                                  .inactiveIngredients,
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontFamily:
                                                                    'PlayfairDisplay - Regular',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 35.0),
                                                      Divider(
                                                        color: Colors.grey,
                                                        thickness: 1,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            "2. Warning: ",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontFamily:
                                                                  'PlayfairDisplay - Regular',
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              for (int i = 1;
                                                                  i <=
                                                                      widget
                                                                          .warnings
                                                                          .length;
                                                                  i++)
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      '$i. ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'PlayfairDisplay - Regular',
                                                                      ),
                                                                    ),
                                                                    ConstrainedBox(
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        maxWidth:
                                                                            MediaQuery.of(context).size.width -
                                                                                200,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        '${widget.warnings[i - 1]} \n',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontFamily:
                                                                              'PlayfairDisplay - Regular',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        color: Colors.grey,
                                                        thickness: 1,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "3. Directions: ",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'PlayfairDisplay - Regular',
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              for (int i = 1;
                                                                  i <=
                                                                      widget
                                                                          .directions
                                                                          .length;
                                                                  i++)
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      '$i. ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'PlayfairDisplay - Regular',
                                                                      ),
                                                                    ),
                                                                    ConstrainedBox(
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        maxWidth:
                                                                            MediaQuery.of(context).size.width -
                                                                                200,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        '${widget.directions[i - 1]} \n',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'PlayfairDisplay - Regular',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        color: Colors.grey,
                                                        thickness: 1,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "4. Used for: ",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'PlayfairDisplay - Regular',
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              for (int i = 1;
                                                                  i <=
                                                                      widget
                                                                          .uses
                                                                          .length;
                                                                  i++)
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      '$i. ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'PlayfairDisplay - Regular',
                                                                      ),
                                                                    ),
                                                                    ConstrainedBox(
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        maxWidth:
                                                                            MediaQuery.of(context).size.width -
                                                                                200,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        '${widget.uses[i - 1]} \n',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'PlayfairDisplay - Regular',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        color: Colors.grey,
                                                        thickness: 1,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.50,
                      child: Hero(
                        tag: widget.heroTag,
                        child: Image(
                          image: NetworkImage(widget.heroTag),
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : CircularProgressIndicator();
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 200,
                              ),
                            );
                          },
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}
