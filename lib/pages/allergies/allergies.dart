import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:universalhaircutz/pages/allergies/allergiesComponents.dart'
    as components;
import 'package:universalhaircutz/services/auth.dart';

class Allergies extends StatefulWidget {
  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {
  bool displayFloatingActionButton = true;

  var uid;

  getUID() async {
    uid = await getCurrentUID();
    return uid;
  }

  @override
  void initState() {
    super.initState();
    checkIfLikedOrNot();
    getUID();
  }

  @override
  void dispose() {
    checkIfLikedOrNot();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergies'),
      ),
      floatingActionButton: displayFloatingActionButton == false
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return FirestoreListView();
                    });
              })
          : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: FutureBuilder(
            future: getCurrentUID(),
            builder: (context, AsyncSnapshot snapshot) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Allergies')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data!.docs.isEmpty)
                    return Center(child: Text("No Allergies found..."));
                  return AllergiesList(documents: snapshot.data!.docs);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  checkIfLikedOrNot() async {
    var uid = await getCurrentUID();
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection("Allergies").doc(uid).get();
    if (mounted)
      setState(() {
        displayFloatingActionButton = ds.exists;
      });
    if (displayFloatingActionButton == true) {
      print('data present');
    } else {
      print('not present');
    }
  }
}

class AllergiesList extends StatefulWidget {
  final List<DocumentSnapshot>? documents;
  const AllergiesList({Key? key, this.documents}) : super(key: key);
  @override
  _AllergiesListState createState() => _AllergiesListState();
}

class _AllergiesListState extends State<AllergiesList> {
  var uid;

  getUID() async {
    uid = await getCurrentUID();
    return uid;
  }

  @override
  void initState() {
    super.initState();
    getUID();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, AsyncSnapshot snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Allergies')
              // //.doc(snapshot.data)
              // //.collection("Allergies")
              // .where("User", isEqualTo: snapshot.data)
              // .orderBy("Date", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null)
              return Center(child: CircularProgressIndicator());
            return Scrollbar(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot point = snapshot.data!.docs[index];

                  if (point.get('User') != uid) {
                    return Container();
                  }
                  return Padding(
                    padding: EdgeInsets?.fromLTRB(12.0, 15, 12.0, 0),
                    child: Container(
                      height: size.height * 0.20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return FirestoreListView(
                                  document: this.widget.documents![index],
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Doctor Name: ' +
                                      '${this.widget.documents![index]['Doctor Name']}'),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Row(
                                children: [
                                  Text('Doctor Number: ' +
                                      '${this.widget.documents![index]['Doctor Number']}'),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Row(
                                children: [
                                  Text('Next of Kin: ' +
                                      '${this.widget.documents![index]['Next of Kin']}'),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Row(
                                children: [
                                  Text('Next of Kin: ' +
                                      '${this.widget.documents![index]['Next of Kin Number']}'),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Row(
                                children: [
                                  Text(
                                    'Allergies: ' +
                                        '${this.widget.documents![index]['Allergies']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class FirestoreListView extends StatefulWidget {
  final DocumentSnapshot? document;
  FirestoreListView({this.document});
  @override
  _FirestoreListViewState createState() => _FirestoreListViewState();
}

class _FirestoreListViewState extends State<FirestoreListView>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  PageController? pageController;

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Field cannot be left empty'),
  ]);

  bool isloading = false;
  bool autoValidate = true;
  String? allergies,
      // ignore: unused_field
      _errorMessage,
      doctorName,
      doctorNumber,
      nextOfKin,
      nextOfKinNumber,
      clientName,
      clientEmail = '';

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);
    getCurrentUserData();

    if (widget.document != null) {
      doctorName = this.widget.document!['Doctor Name'];
      doctorNumber = this.widget.document!['Doctor Number'];
      nextOfKin = this.widget.document!['Next of Kin'];
      allergies = this.widget.document!['Allergies'];
      nextOfKinNumber = this.widget.document!['Next of Kin Number'];
    }
  }

  getCurrentUserData() async {
    User user = FirebaseAuth.instance.currentUser!;
    setState(() {
      clientName = user.displayName;
      clientEmail = user.email;
    });
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(fontFamily: 'PlayfairDisplay'),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      onPressed: () {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot =
              await transaction.get(widget.document!.reference);
          transaction.delete(snapshot.reference);
          Fluttertoast.showToast(
            msg: 'Allergies Deleted',
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.pop(context);
          Navigator.pop(context);
        }).catchError(
          (onError) {
            print("Error");
            Fluttertoast.showToast(
                msg: "Please try again or" + " connect to a stable network",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.grey[700],
                textColor: Colors.grey[50],
                gravity: ToastGravity.CENTER);
            Navigator.pop(context);
          },
        );
      },
      child: Text(
        "Ok",
        style: TextStyle(fontFamily: 'PlayfairDisplay'),
      ),
    );

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Delete Allergies",
              style: TextStyle(fontFamily: 'PlayfairDisplay - Regular'),
            ),
            content: Text(
              "Are you sure you want to permanently delete this Allergies?",
              style: TextStyle(
                  fontSize: 12.0, fontFamily: 'PlayfairDisplay - Regular'),
            ),
            actions: <Widget>[
              cancelButton,
              okButton,
            ],
          );
        },
      );
    }

    void _showDialog2() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Network Failure"),
            content: Wrap(
              children: [
                Text("Allergies will be saved automatically"
                    " when you reconnect to a stable network.")
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Feed Back Details'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          //height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(75.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50.0),
              Text(
                'Fill Out Application Form',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 16.0,
                ),
              ),
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: size.height * 0.12),
                      TextFormField(
                        decoration: components.textFieldInputDecoration(
                            context, "Doctor's name"),
                        onSaved: (value) => doctorName = value,
                        initialValue: doctorName,
                        validator: (value) =>
                            value!.isEmpty ? "Enter your doctor's name" : null,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: size.height * 0.05),
                      TextFormField(
                        decoration: components.textFieldInputDecoration(
                            context, "Doctor's contact number"),
                        onSaved: (value) => doctorNumber = value,
                        initialValue: doctorNumber,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter phone number' : null,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: size.height * 0.05),
                      TextFormField(
                        decoration: components.textFieldInputDecoration(
                            context, 'Next of kin'),
                        onSaved: (value) => nextOfKin = value,
                        initialValue: nextOfKin,
                        validator: (value) => value!.isEmpty
                            ? 'Enter the name of a person to be contacted incase of an emergency'
                            : null,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: size.height * 0.05),
                      TextFormField(
                        decoration: components.textFieldInputDecoration(
                            context, 'Next of kin number'),
                        onSaved: (value) => nextOfKinNumber = value,
                        initialValue: nextOfKinNumber,
                        validator: (value) => value!.isEmpty
                            ? "Enter a person's # to be contacted incase of an emergency"
                            : null,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: size.height * 0.05),
                      TextFormField(
                        maxLines: 5,
                        decoration: components.textFieldInputDecoration(
                            context, 'Enter your known allergies here'),
                        enabled: !isloading,
                        onSaved: (value) => allergies = value,
                        initialValue: allergies,
                        maxLength: 200,
                        validator: passwordValidator,
                        keyboardType: TextInputType.text,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: isloading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      this.widget.document != null
                                          ? MainAxisAlignment.spaceBetween
                                          : MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: SizedBox(
                                        height: 50.0,
                                        width: 120,
                                        child: MaterialButton(
                                          color: Theme.of(context).primaryColor,
                                          child: Text(
                                            "Save Report",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              try {
                                                if (mounted)
                                                  setState(() {
                                                    isloading = !isloading;
                                                    _errorMessage = '';
                                                  });
                                                _formkey.currentState!.save();
                                                var id = await getCurrentUID();
                                                var date = FieldValue
                                                    .serverTimestamp();
                                                var feedObject = {
                                                  "User": id,
                                                  "Client Name": clientName,
                                                  "Client Email": clientEmail,
                                                  "Allergies": allergies,
                                                  "Doctor Name": doctorName,
                                                  "Doctor Number": doctorNumber,
                                                  "Next of Kin": nextOfKin,
                                                  "Next of Kin Number":
                                                      nextOfKinNumber,
                                                  "Date": date,
                                                };
                                                widget.document == null
                                                    ? FirebaseFirestore.instance
                                                        .collection('Allergies')
                                                        .doc(id)
                                                        .set(feedObject)
                                                        .then((value) {
                                                        Fluttertoast.showToast(
                                                            msg: 'Your Allergies' +
                                                                ' has been saved');

                                                        Navigator.pop(context);
                                                      }).timeout(
                                                            Duration(
                                                                seconds: 10),
                                                            onTimeout: () {
                                                        setState(() {
                                                          isloading = false;
                                                          _showDialog2();
                                                          print("Error");
                                                        });
                                                      })
                                                    : FirebaseFirestore.instance
                                                        .runTransaction(
                                                            (transaction) async {
                                                        DocumentSnapshot
                                                            snapshot =
                                                            await transaction
                                                                .get(widget
                                                                    .document!
                                                                    .reference);

                                                        transaction.update(
                                                            snapshot.reference,
                                                            feedObject);

                                                        Fluttertoast.showToast(
                                                          msg:
                                                              'Your Allergies has' +
                                                                  ' been saved',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                        );
                                                        Navigator.pop(context);
                                                      }).catchError((onError) {
                                                        setState(() {
                                                          isloading = false;
                                                          Fluttertoast.showToast(
                                                              msg: "Please try again or" +
                                                                  " connect to a stable network",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      700],
                                                              textColor: Colors
                                                                  .grey[50],
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                          print("Error");
                                                        });
                                                      });
                                              } catch (e) {
                                                if (mounted)
                                                  setState(() {
                                                    isloading = false;
                                                    _errorMessage =
                                                        e.toString();
                                                  });
                                                print(e);
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    if (this.widget.document != null)
                                      SizedBox(
                                        width: 120.0,
                                        height: 50.0,
                                        child: MaterialButton(
                                          color: Theme.of(context).primaryColor,
                                          child: Text(
                                            'Delete Allergies',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            _showDialog();
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
