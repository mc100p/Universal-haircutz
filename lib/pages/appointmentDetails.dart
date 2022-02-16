import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

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

  var value;

  int savedCount = 0;

  final initialValue = DateTime.now();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
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
              width: double.infinity,
              child: TabBar(
                labelStyle: TextStyle(color: Colors.white),
                unselectedLabelColor: Colors.blue[900],
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
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.08),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: DateTimeField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  new Radius.circular(10.0),
                                ),
                              ),
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2020),
                                  initialDate: currentValue!,
                                  lastDate: DateTime(2500));

                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      TimeOfDay.fromDateTime(currentValue),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                            autovalidateMode: AutovalidateMode.always,
                            // ignore: unnecessary_null_comparison
                            validator: (date) =>
                                date.toString() == null ? 'Invalid date' : null,
                            initialValue: initialValue,
                            onChanged: (date) => setState(() {
                              value = date;
                            }),
                            onSaved: (date) => setState(
                              () {
                                value = date;
                                savedCount++;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text("Hello World"),
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
