import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:universalhaircutz/services/auth.dart';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  GlobalKey keyButton = GlobalKey();

  final format = DateFormat("yyyy-MM-dd - hh:mm ");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule Appointment")),
      body: Container(
        child: FutureBuilder(
          future: getCurrentUID(),
          builder: (context, AsyncSnapshot snapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Appointments')
                  //.doc(snapshot.data)
                  // .where("User", isEqualTo: snapshot.data)
                  // .orderBy("Appointment", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else if (snapshot.data!.docs.isEmpty)
                  return Center(
                    child: Text(
                      "No appointments made.",
                    ),
                  );
                return AppointmentList(
                  documents: snapshot.data!.docs,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getUsersDataStreamSnapshot(
      BuildContext context) async* {
    // ignore: unused_local_variable
    final uid = await getCurrentUser();
    yield* FirebaseFirestore.instance.collection('Appointments').snapshots();
  }
}

class AppointmentList extends StatefulWidget {
  final List<DocumentSnapshot>? documents;

  const AppointmentList({
    Key? key,
    this.documents,
  }) : super(key: key);
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
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
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, AsyncSnapshot snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Appointments')
              // .doc(snapshot.data)
              // .collection("Appointments")
              // .where("User", isEqualTo: snapshot.data)
              // .orderBy("Appointment", descending: true)
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

                  if (point.get('id') != uid) {
                    return Container();
                  }
                  return Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 25, 12.0, 0),
                    child: Shimmer(
                      duration: Duration(seconds: 3),
                      interval: Duration(seconds: 5),
                      color: Colors.white,
                      enabled: true,
                      direction: ShimmerDirection.fromLTRB(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return FirestoreListView(
                                  document: this.widget.documents![index],
                                );
                              },
                            );
                          },
                          title: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Appointment Details",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'PlayfairDisplay'),
                                ),
                                Divider(
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Date: ",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                'PlayfairDisplay  - Regular',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '${this.widget.documents![index]['Appointment Time'].toDate()}',
                                          style: TextStyle(
                                            fontFamily:
                                                'PlayfairDisplay - Regular',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Barber Selected: ",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                'PlayfairDisplay  - Regular',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '${this.widget.documents![index]['Barber name']}',
                                          style: TextStyle(
                                            fontFamily:
                                                'PlayfairDisplay - Regular',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Barber email: ",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                'PlayfairDisplay  - Regular',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '${this.widget.documents![index]['Barber email']}',
                                          style: TextStyle(
                                            fontFamily:
                                                'PlayfairDisplay - Regular',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Cost: ",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                'PlayfairDisplay  - Regular',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '${this.widget.documents![index]['Cost']}',
                                          style: TextStyle(
                                            fontFamily:
                                                'PlayfairDisplay - Regular',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          " Service: ",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily:
                                                'PlayfairDisplay  - Regular',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '${this.widget.documents![index]['Service']}',
                                          style: TextStyle(
                                            fontFamily:
                                                'PlayfairDisplay - Regular',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Image(
                                  image: NetworkImage(
                                      '${this.widget.documents![index]['Image of serice']}'),
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : Center(
                                            child: CircularProgressIndicator());
                                  },
                                  fit: BoxFit.contain,
                                  height: 50.0,
                                  width: 50.0,
                                ),
                              ],
                            ),
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
  PageController? pageController;

  User user = FirebaseAuth.instance.currentUser!;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedUser, barberName;

  // ignore: unused_field
  String _errorMessage = '';

  final format = DateFormat("MMM dd, yyyy - h:mm ");

  final initialValue = DateTime.now();

  bool isloading = false;

  bool autoValidate = true;

  bool readOnly = true;

  var appointment;

  var value;

  int changedCount = 0;

  int savedCount = 0;

  String? doctorsID;

  String? barberEmail, cost, service, imgUrl;

  String? bEmail, bCost, bService, bImgurl;

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);
    if (widget.document != null) {
      appointment = this.widget.document!['Appointment Time'].toDate();
      barberName = this.widget.document!['Barber name'];
      barberEmail = this.widget.document!['Barber email'];
      service = this.widget.document!['Service'];
      cost = this.widget.document!['Cost'];
      //barberEmail = this.widget.document!['Baber email'];
      // cost = this.widget.document!['Cost'];
      imgUrl = this.widget.document!['Image of serice'];
    }
    selectedUser = barberName;
    value = appointment;
    bService = service;
    bEmail = barberEmail;
    bCost = cost;
    bImgurl = imgUrl;
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Text(
        "Ok",
        style: TextStyle(fontFamily: 'PlayfairDisplay'),
      ),
      onPressed: () {
        FirebaseFirestore.instance.runTransaction(
          (transaction) async {
            DocumentSnapshot snapshot =
                await transaction.get(widget.document!.reference);
            transaction.delete(snapshot.reference);
            Fluttertoast.showToast(
              msg: 'Appointment Deleted',
              toastLength: Toast.LENGTH_SHORT,
            );
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ).catchError((onError) {
          print("Error");
          Fluttertoast.showToast(
              msg: "Please try again or" + " connect to a stable network",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.grey[700],
              textColor: Colors.grey[50],
              gravity: ToastGravity.CENTER);
          Navigator.pop(context);
        });
      },
    );

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Delete Appointment",
              style: TextStyle(fontFamily: 'PlayfairDisplay - Regular'),
            ),
            content: Text(
              "Are you sure you want to " +
                  "permanently delete this Appointment?",
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
            title: Text("Appointment Saved"),
            content: Wrap(
              children: [
                Text("Network Connection is not stable, your appointment"
                    " will still be saved when you reconnect to a stable"
                    " network connection")
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
      appBar: AppBar(title: Text("Appointment Details")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Barbers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(),
            );
          // ignore: unused_local_variable
          var length = snapshot.data!.docs.length;

          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: <Widget>[
                        // SizedBox(height: 30.0),
                        // Text(
                        //   'Select a barber for appointment',
                        //   style: TextStyle(
                        //     fontSize: 16.0,
                        //     fontFamily: 'PlayfairDisplay',
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 18.0),
                        //   child: Divider(
                        //     thickness: 3,
                        //   ),
                        // ),
                        Form(
                          key: _formKey,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                // SizedBox(
                                //   width: MediaQuery.of(context).size.width - 50,
                                //   height: 95.0,
                                //   child: Container(
                                //     margin: EdgeInsets.only(top: 25),
                                //     padding: EdgeInsets.all(15),
                                //     decoration: BoxDecoration(
                                //       border: new Border.all(
                                //         color: Colors.grey,
                                //       ),
                                //       borderRadius: new BorderRadius.all(
                                //         new Radius.circular(
                                //           10.0,
                                //         ),
                                //       ),
                                //     ),
                                //     child: Row(
                                //       children: <Widget>[
                                //         Expanded(
                                //           child: DropdownButtonHideUnderline(
                                //             child: ButtonTheme(
                                //               alignedDropdown: true,
                                //               child: DropdownButton(
                                //                 icon: Container(),
                                //                 isDense: true,
                                //                 hint: new Text("Select Barber"),
                                //                 value: selectedUser,
                                //                 onChanged: (String? newValue) {
                                //                   if (mounted)
                                //                     setState(() {
                                //                       selectedUser = newValue;
                                //                     });
                                //                   print(selectedUser);
                                //                 },
                                //                 items: snapshot.data!.docs.map(
                                //                   (DocumentSnapshot document) {
                                //                     var barberID = document
                                //                         .get("barberID");

                                //                     barberID = barberID;

                                //                     return new DropdownMenuItem<
                                //                         String>(
                                //                       value: document
                                //                           .get("FullName"),
                                //                       child: Row(
                                //                         mainAxisAlignment:
                                //                             MainAxisAlignment
                                //                                 .spaceBetween,
                                //                         children: <Widget>[
                                //                           ClipOval(
                                //                             child: Image(
                                //                               image:
                                //                                   NetworkImage(
                                //                                 document.get(
                                //                                     'imgUrl'),
                                //                               ),
                                //                               loadingBuilder:
                                //                                   (context,
                                //                                       child,
                                //                                       progress) {
                                //                                 return progress ==
                                //                                         null
                                //                                     ? child
                                //                                     : Center(
                                //                                         child:
                                //                                             CircularProgressIndicator());
                                //                               },
                                //                               fit: BoxFit
                                //                                   .contain,
                                //                               height: 50.0,
                                //                               width: 50.0,
                                //                             ),
                                //                           ),
                                //                           Container(
                                //                             child: Text(
                                //                               document
                                //                                   .get("email"),
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     );
                                //                   },
                                //                 ).toList(),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                // SizedBox(
                                //   width: MediaQuery.of(context).size.width - 50,
                                //   child: DateTimeField(
                                //     decoration: InputDecoration(
                                //       border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.all(
                                //           new Radius.circular(10.0),
                                //         ),
                                //       ),
                                //     ),
                                //     format: format,
                                //     resetIcon: null,
                                //     onShowPicker:
                                //         (context, currentValue) async {
                                //       final date = await showDatePicker(
                                //           context: context,
                                //           firstDate: DateTime(2020),
                                //           initialDate: currentValue!,
                                //           lastDate: DateTime(2500));

                                //       if (date != null) {
                                //         final time = await showTimePicker(
                                //           context: context,
                                //           initialTime: TimeOfDay.fromDateTime(
                                //               currentValue),
                                //         );
                                //         return DateTimeField.combine(
                                //             date, time);
                                //       } else {
                                //         return currentValue;
                                //       }
                                //     },
                                //     autovalidateMode: AutovalidateMode.always,
                                //     // ignore: unnecessary_null_comparison
                                //     validator: (date) => date.toString() == null
                                //         ? 'Invalid date'
                                //         : null,
                                //     initialValue: initialValue,
                                //     onChanged: (date) => setState(() {
                                //       value = date;
                                //     }),
                                //     onSaved: (date) => setState(
                                //       () {
                                //         value = date;
                                //         savedCount++;
                                //       },
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 50.0),
                                      Text(
                                        'Appointment Details',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'PlayfairDisplay',
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Divider(
                                          thickness: 3,
                                        ),
                                      ),
                                      ClipOval(
                                        child: Image(
                                          image: NetworkImage(
                                            bImgurl!,
                                          ),
                                          loadingBuilder:
                                              (context, child, progress) {
                                            return progress == null
                                                ? child
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator());
                                          },
                                          fit: BoxFit.contain,
                                          height: 150.0,
                                          width: 150.0,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '1. Date & Time: ',
                                            style: TextStyle(
                                              fontFamily:
                                                  'PlayfairDisplay  - Regular',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  100,
                                            ),
                                            child: Text(
                                              '$value',
                                              style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '2. Barber Selected: ',
                                            style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            '$selectedUser',
                                            style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay  - Regular',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '3. Barber email: ',
                                            style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            '$bEmail',
                                            style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay  - Regular',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '4. Service: ',
                                            style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            '$bService',
                                            style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay  - Regular',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '5. Cost: ',
                                            style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            '$bCost',
                                            style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay  - Regular',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: isloading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // this.widget.document != null
                                  //     ? MainAxisAlignment.spaceBetween
                                  //     : MainAxisAlignment.center,
                                  children: <Widget>[
                                    // SizedBox(
                                    //   height: 50.0,
                                    //   width: 120,
                                    //   child: MaterialButton(
                                    //     color: Theme.of(context).primaryColor,
                                    //     child: Text(
                                    //       "Save Appointment",
                                    //       style: TextStyle(
                                    //           color: Colors.white,
                                    //           fontSize: 13,
                                    //           fontFamily:
                                    //               'PlayfairDisplay - Regular'),
                                    //     ),
                                    //     onPressed: () async {
                                    //       if (_formKey.currentState!
                                    //           .validate()) {
                                    //         try {
                                    //           if (mounted)
                                    //             setState(() {
                                    //               isloading = !isloading;
                                    //               _errorMessage = '';
                                    //             });
                                    //           _formKey.currentState!.save();
                                    //           var id = await getCurrentUID();

                                    //           var date =
                                    //               FieldValue.serverTimestamp();
                                    //           user.photoURL;
                                    //           user.displayName;
                                    //           await user.reload();
                                    //           var appointmentObject = {
                                    //             "User": id,
                                    //             "Doctor": selectedUser,
                                    //             "Appointment": value,
                                    //             "Booked_on": date,
                                    //             "User_Name": user.displayName,
                                    //             "User_Email": user.email,
                                    //             "DoctorsID": doctorsID,
                                    //             "User_Photo": user.photoURL,
                                    //           };
                                    //           widget.document == null
                                    //               ? FirebaseFirestore.instance
                                    //                   .collection(
                                    //                       'Appointments')
                                    //                   .add(appointmentObject)
                                    //                   .then((value) {
                                    //                   Fluttertoast.showToast(
                                    //                       msg:
                                    //                           'Your appointment has been saved');
                                    //                   Navigator.pop(context);
                                    //                 }).timeout(
                                    //                       Duration(seconds: 5),
                                    //                       onTimeout: () {
                                    //                   setState(() {
                                    //                     isloading = false;
                                    //                     _showDialog2();
                                    //                     print("Error");
                                    //                   });
                                    //                 })
                                    //               : FirebaseFirestore.instance
                                    //                   .runTransaction(
                                    //                       (transaction) async {
                                    //                   DocumentSnapshot
                                    //                       snapshot =
                                    //                       await transaction.get(
                                    //                           widget.document!
                                    //                               .reference);
                                    //                   transaction.update(
                                    //                       snapshot.reference,
                                    //                       appointmentObject);

                                    //                   Fluttertoast.showToast(
                                    //                       msg:
                                    //                           'Your appointment has been saved',
                                    //                       toastLength: Toast
                                    //                           .LENGTH_SHORT);
                                    //                   Navigator.pop(context);
                                    //                 }).catchError(
                                    //                   (onError) {
                                    //                     setState(
                                    //                       () {
                                    //                         isloading = false;
                                    //                         Fluttertoast.showToast(
                                    //                             msg: "Please try again or" +
                                    //                                 " connect to a stable network",
                                    //                             toastLength: Toast
                                    //                                 .LENGTH_LONG,
                                    //                             backgroundColor:
                                    //                                 Colors.grey[
                                    //                                     700],
                                    //                             textColor:
                                    //                                 Colors.grey[
                                    //                                     50],
                                    //                             gravity:
                                    //                                 ToastGravity
                                    //                                     .CENTER);
                                    //                       },
                                    //                     );
                                    //                   },
                                    //                 );
                                    //         } catch (e) {
                                    //           if (mounted)
                                    //             setState(
                                    //               () {
                                    //                 isloading = false;
                                    //                 _errorMessage =
                                    //                     e.toString();
                                    //               },
                                    //             );
                                    //           print(e);
                                    //         }
                                    //       }
                                    //     },
                                    //   ),
                                    // ),
                                    if (this.widget.document != null)
                                      SizedBox(
                                        width: 120.0,
                                        height: 50.0,
                                        child: MaterialButton(
                                          color: Theme.of(context).primaryColor,
                                          child: Text(
                                            'Delete Appointment',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.0,
                                              fontFamily:
                                                  'PlayfairDisplay-Regular',
                                            ),
                                          ),
                                          onPressed: () {
                                            _showDialog();
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
