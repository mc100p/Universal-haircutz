import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:universalhaircutz/services/auth.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: FutureBuilder(
            future: getCurrentUID(),
            builder: (context, AsyncSnapshot snapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Cart').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data!.docs.isEmpty)
                    return Center(
                      child: Text("Nothing added to cart"),
                    );
                  return CartList(documents: snapshot.data!.docs);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class CartList extends StatefulWidget {
  CartList({Key? key, this.documents}) : super(key: key);
  final List<DocumentSnapshot>? documents;

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  double mean = 0.0;

  var uid;
  bool purchasePossible = false;

  getUID() async {
    uid = await getCurrentUID();
    return uid;
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
  void initState() {
    super.initState();
    getUID();
    isPurchasePossible();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getCurrentUID(),
            builder: (context, AsyncSnapshot snapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Cart').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null)
                    return Center(child: CircularProgressIndicator());
                  double value = 0.0;
                  double total = 0.0;
                  return Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemBuilder: (context, index) {
                              DocumentSnapshot point =
                                  snapshot.data!.docs[index];

                              if (point.get('Uid') != uid) {
                                return Container();
                              }
                              double myPrices = double.parse(
                                point['Price'].toString().replaceAll(",", ""),
                              );
                              int myQuantity = int.parse(
                                point['Quantity']
                                    .toString()
                                    .replaceAll(",", ""),
                              );

                              value = myPrices * myQuantity;

                              total += value;

                              mean = total;
                              return SingleChildScrollView(
                                child: Container(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return PopUp(
                                              document:
                                                  snapshot.data!.docs[index],
                                            );
                                          });
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image(
                                              image: NetworkImage(
                                                  '${point['Item name']}'),
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
                                                  child: Icon(
                                                    Icons.broken_image_outlined,
                                                    size: 50,
                                                  ),
                                                );
                                              },
                                              fit: BoxFit.cover,
                                              height: 50.0,
                                              width: 50.0,
                                            ),
                                            Text(
                                              '${point["product name"]}',
                                              style: TextStyle(
                                                fontFamily: 'PlayfairDisplay',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Text(
                                              '${formatCurrency.format(myPrices)}',
                                              style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text("x"),
                                                Text(
                                                  myQuantity.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                        'PlayfairDisplay - Regular',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.grey[700],
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    mean = total;
                                  },
                                );
                              },
                              child: Text(
                                "Click for total:",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Text(
                              '${formatCurrency.format(mean)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: MediaQuery.of(context).size.height / 10,
                        child: MaterialButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: purchasePossible
                              ? () {
                                  mean != 0
                                      ? showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CheckOutDialog();
                                          })
                                      : Fluttertoast.showToast(
                                          msg: "Cart empty",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.grey[700],
                                          textColor: Colors.white);
                                }
                              : () {
                                  showDialog(
                                      context: context,
                                      builder: (builder) {
                                        return AlertDialog(
                                          title: Text('No Allergies Provided'),
                                          content: SingleChildScrollView(
                                            child: Text(
                                                'An allergy report must be provided before any products can be purchased'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.popAndPushNamed(
                                                    context, '/allergies');
                                              },
                                              child: Text('Provide Report'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                          child: Text(
                            "Check Out",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopUp extends StatefulWidget {
  final DocumentSnapshot? document;
  PopUp({this.document});
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Cancel",
          style: TextStyle(fontFamily: 'PlayfairDisplay'),
        ));
    Widget okButton = TextButton(
      onPressed: () {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot =
              await transaction.get(widget.document!.reference);
          transaction.delete(snapshot.reference);
          Fluttertoast.showToast(
              msg: 'Item removed', toastLength: Toast.LENGTH_SHORT);
          Navigator.pop(context);
        }).catchError(
          (onError) {
            print("Error");
            Fluttertoast.showToast(
                msg: "Item failed to remove from cart,"
                    " please check internet connection.",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.grey[700],
                textColor: Colors.grey[50],
                gravity: ToastGravity.CENTER);
            Navigator.pop(context);
          },
        );
      },
      child: Text("Ok", style: TextStyle(fontFamily: 'PlayfairDisplay')),
    );

    return AlertDialog(
      title: Text(
        "Remove Item from Cart?",
        style: TextStyle(fontFamily: 'PlayfairDisplay - Regular'),
      ),
      content: Text(
        "Are you sure you want to remove this item from your cart?",
        style: TextStyle(fontFamily: 'PlayfairDisplay - Regular'),
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );
  }
}

class CheckOutDialog extends StatefulWidget {
  @override
  _CheckOutDialogState createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PageController? pageController;

  String _errorMessage = '';

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "Enter Card Information",
                      style: TextStyle(
                          fontSize: 20.0, fontFamily: 'PlayfairDisplay'),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(height: 10.0),
                    Form(
                      key: _formKey,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(10.0))),
                                      hintText: "1234-5478-9876-5432",
                                      hintStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter your card details'
                                      : null,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 50,
                                height: MediaQuery.of(context).size.height / 15,
                                child: isloading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
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
                                        child: MaterialButton(
                                          onPressed: confirm,
                                          color: Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          child: new Text(
                                            "Pay Now",
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          splashColor: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Divider(
                              thickness: 3,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  void confirm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/userHomePage', (Route<dynamic> route) => false);
        Fluttertoast.showToast(
          msg:
              "We will validate this transaction then send you an Order ID shortly.",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey[700],
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );
      } catch (e) {
        setState(() {
          isloading = false;
          _errorMessage = e.toString();
        });
        print(e);
      }
    }
  }
}
