import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:universalhaircutz/services/auth.dart';
import 'package:universalhaircutz/utils/widget.dart';

class AppointmentSetUp extends StatefulWidget {
  final heroTag;
  final name;
  final price;
  final barberName;
  final barberEmail;
  final barberImage;

  const AppointmentSetUp({
    Key? key,
    this.heroTag,
    this.name,
    this.price,
    this.barberName,
    this.barberEmail,
    this.barberImage,
  }) : super(key: key);
  @override
  State<AppointmentSetUp> createState() => _AppointmentSetUpState();
}

class _AppointmentSetUpState extends State<AppointmentSetUp>
    with SingleTickerProviderStateMixin {
  final format = DateFormat("yyyy-MM-dd - hh:mm ");

  DateTime? appointmentTime;

  int savedCount = 0;

  final initialValue = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TabController tabController;

  bool button = false;

  bool purchasePossible = false;

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
    isPurchasePossible();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${this.widget.barberName}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.45,
              child: Image(
                image: NetworkImage(
                  this.widget.barberImage,
                ),
                loadingBuilder: (context, child, progress) {
                  return progress == null ? child : CircularProgressIndicator();
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Icon(Icons.broken_image_outlined),
                  );
                },
                fit: BoxFit.cover,
                height: 75.0,
                width: 75.0,
              ),
            ),
            Container(
              color: Theme.of(context).cardColor,
              width: double.infinity,
              child: TabBar(
                labelStyle: TextStyle(color: Colors.white),
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                controller: tabController,
                tabs: <Tab>[
                  Tab(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Information Form",
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Center(
                        child: Text(
                          "Details",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: size.height,
              child: TabBarView(
                controller: tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.08),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text('Select a time for appointment'),
                                  Divider(
                                    thickness: 1.8,
                                  ),
                                  SizedBox(height: size.height * 0.08),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: DateTimeField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            new Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      resetIcon: null,
                                      format: format,
                                      onEditingComplete: () {
                                        setState(() {
                                          appointmentTime = DateTime.now();
                                        });
                                      },
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(2020),
                                            initialDate: currentValue!,
                                            lastDate: DateTime(2500));

                                        if (date != null) {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.fromDateTime(
                                                currentValue),
                                          );
                                          return DateTimeField.combine(
                                              date, time);
                                        } else {
                                          return currentValue;
                                        }
                                      },
                                      autovalidateMode: AutovalidateMode.always,
                                      // ignore: unnecessary_null_comparison
                                      validator: (date) =>
                                          date.toString() == null
                                              ? 'Invalid date'
                                              : null,
                                      initialValue: initialValue,
                                      onChanged: (date) => setState(() {
                                        appointmentTime = date;
                                      }),
                                      onSaved: (date) => setState(
                                        () {
                                          appointmentTime = date;
                                          savedCount++;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: button
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : SizedBox(
                                            height: size.height / 12,
                                            width: size.width - 40,
                                            child: MaterialButton(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Text(
                                                "Save Appointment",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Arial'),
                                              ),
                                              onPressed: purchasePossible
                                                  ? () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        print(appointmentTime);

                                                        var id =
                                                            await getCurrentUID();

                                                        var date = FieldValue
                                                            .serverTimestamp();
                                                        if (appointmentTime ==
                                                            null) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  errorDisplay(
                                                                      "Please select a convenient time"));
                                                        } else {
                                                          var appointmentObject =
                                                              {
                                                            'Appointment Time':
                                                                appointmentTime,
                                                            'Barber name': this
                                                                .widget
                                                                .barberName,
                                                            'Barber email': this
                                                                .widget
                                                                .barberEmail,
                                                            'Service': this
                                                                .widget
                                                                .name,
                                                            'Cost': this
                                                                .widget
                                                                .price,
                                                            'Image of serice':
                                                                this
                                                                    .widget
                                                                    .heroTag,
                                                            'id': id,
                                                            'date': date,
                                                          };

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Appointments')
                                                              .add(
                                                                  appointmentObject)
                                                              .then((value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    successDisplay(
                                                                        "Appointment Saved!"));

                                                            Navigator.of(
                                                                    context)
                                                                .pushNamedAndRemoveUntil(
                                                                    '/userHomePage',
                                                                    (Route<dynamic>
                                                                            route) =>
                                                                        false);
                                                          }).timeout(
                                                                  Duration(
                                                                      seconds:
                                                                          5),
                                                                  onTimeout:
                                                                      () {
                                                            setState(() {
                                                              button = false;
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      errorDisplay(
                                                                          "Failed to book appointment try again"));
                                                              print("Error");
                                                            });
                                                          });
                                                        }
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
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.popAndPushNamed(
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: size.height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.08),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Hero(
                                  tag: this.widget.heroTag,
                                  child: Image(
                                    image: NetworkImage(
                                      this.widget.heroTag,
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
                                        child:
                                            Icon(Icons.broken_image_outlined),
                                      );
                                    },
                                    fit: BoxFit.cover,
                                    height: 150.0,
                                    width: 150.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.08),
                          Row(
                            children: [
                              Text('Barber Name: '),
                              Text(
                                '${this.widget.barberName}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Barber Email: '),
                              Text(
                                '${this.widget.barberEmail}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Service: '),
                              Text(
                                '${this.widget.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Cost: '),
                              Text(
                                '${this.widget.price}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (appointmentTime == null) ...[
                                Text('Appointment Time: '),
                                Text(''),
                              ] else ...[
                                Text('Appointment Time: '),
                                Text(
                                  '$appointmentTime',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
