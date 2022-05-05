import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universalhaircutz/adminPanel/adminComponents.dart';
import 'package:universalhaircutz/adminPanel/viewInventory.dart';
import 'package:universalhaircutz/services/auth.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  var uid;
  var encrpytedPassword;
  getUser() async {
    var value = await getCurrentUID();
    setState(() {
      uid = value;
    });
    print('uid admin: $uid');
    return uid;
  }

  getSharedPreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    encrpytedPassword = prefs.getString('password');
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getSharedPreferenceData();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.60),
                              child: Text(
                                notification.body.toString(),
                                style: TextStyle(fontSize: 12.0),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Ok',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
        // flutterLocalNotificationsPlugin.show(
        //     notification.hashCode,
        //     notification.title,
        //     notification.body,
        //     NotificationDetails(
        //         android: AndroidNotificationDetails(
        //       channel.id,
        //       channel.name,
        //       channelDescription: channel.description,
        //       playSound: true,
        //       icon: "@mipmap/ic_launcher",
        //     )));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.60),
                              child: Text(
                                notification.body.toString(),
                                style: TextStyle(fontSize: 12.0),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Ok',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('admin: $uid');
    return Scaffold(
      drawer: AdminDrawerClass(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 25,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, AsyncSnapshot snapshot) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(snapshot.data)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                Center(child: CircularProgressIndicator());
              else if (snapshot.connectionState == ConnectionState.active)
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Hello,",
                                      style: TextStyle(fontSize: 22.0),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data!['FullName'],
                                      style: TextStyle(
                                        fontSize: 26.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 30),
                    ),
                    SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 15,
                      children: [
                        // InkWell(
                        //     onTap: () =>
                        //         Navigator.pushNamed(context, '/shaving'),
                        //     child: containerService(
                        //         context, 'images/razor.png', 'Shaving')),
                        // InkWell(
                        //   onTap: () =>
                        //       Navigator.pushNamed(context, '/hairProducts'),
                        //   child: containerService(
                        //       context, 'images/shower.png', 'Hair Products'),
                        // ),
                        // InkWell(
                        //     onTap: () =>
                        //         Navigator.pushNamed(context, '/hairCare'),
                        //     child: containerService(
                        //         context, 'images/hair-gel.png', 'Hair Care')),
                        // InkWell(
                        //   onTap: () =>
                        //       Navigator.pushNamed(context, '/grooming'),
                        //   child: containerService(
                        //       context, 'images/hair-style.png', 'Hair Styles'),
                        // ),
                      ],
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 20),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 10,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Theme.of(context).cardColor,
                            onPressed: () => Navigator.pushNamed(
                                context, '/adminReservations'),
                            child: Text(
                              'Appointments',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 20),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 30),
                    ),
                    ViewInventory(
                      uid: uid,
                      encrpytedPassword: encrpytedPassword,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 50),
                    ),
                  ],
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
