import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/pages/allergies/allergies.dart';
import 'package:universalhaircutz/pages/drawer/drawer.dart';
import 'package:universalhaircutz/pages/reservations/reservation.dart';
import 'package:universalhaircutz/services/auth.dart';
import 'package:universalhaircutz/utils/containerLayout.dart';
import 'package:universalhaircutz/utils/custom_icons_icons.dart';

class Pages extends StatefulWidget {
  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  void _onTap(int value) {
    setState(() {
      _currentIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Color.fromARGB(255, 4, 21, 34),
        showElevation: true,
        selectedIndex: _currentIndex,
        onItemSelected: _onTap,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: null,
            title: Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(CustomIcons.home, color: Colors.white),
          ),
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: null,
            title: Text(
              "Appointments",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(CustomIcons.appointments, color: Colors.white),
          ),
          // BottomNavyBarItem(
          //   activeColor: Theme.of(context).primaryColor,
          //   inactiveColor: null,
          //   title: Text(
          //     "Profile",
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   icon: Icon(CustomIcons.profile, color: Colors.white),
          // ),
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: null,
            title: Text(
              "Allergies",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.sick,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          MyHomePage(),
          Appointment(),
          //Profile(),
          Allergies(),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerClass(),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   leading: Builder(
      //     builder: (BuildContext context) {
      //       return IconButton(
      //         icon: const Icon(
      //           Icons.menu,
      //           size: 25,
      //         ),
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer();
      //         },
      //         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      //       );
      //     },
      //   ),
      // ),
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
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      stretch: true,
                      backgroundColor: Colors.transparent,
                      expandedHeight: size.height * 0.40,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          child: !snapshot.hasData
                              ? Center(child: CircularProgressIndicator())
                              : Container(
                                  child: Stack(
                                    children: [
                                      CustomPaint(
                                        size:
                                            Size(double.infinity, size.height),
                                        painter: RPSCustomPainter(context),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 40.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.menu,
                                                      size: 23,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Scaffold.of(context)
                                                          .openDrawer();
                                                    },
                                                    tooltip: MaterialLocalizations
                                                            .of(context)
                                                        .openAppDrawerTooltip,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 30.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Icon(
                                                            CustomIcons.profile,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 20.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Welcome',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.02),
                                                        Text(
                                                          '${snapshot.data!['FullName']}!',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 28.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Let your hair do the talking",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: size.width * 0.50,
                                                height: size.height * 0.03,
                                                color: Colors.white,
                                                child: Text("Search"),
                                              ),
                                              Icon(Icons.search,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        collapseMode: CollapseMode.pin,
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    //     child: Column(
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Text(
                    //               "Next Task",
                    //               style: TextStyle(fontSize: 18.0),
                    //             )
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/shaving'),
                                  child: containerService(context,
                                      'images/razor.png', 'Shaving', size)),
                              SizedBox(width: size.width * 0.10),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, '/hairProducts'),
                                child: containerService(context,
                                    'images/shower.png', 'Hair Products', size),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/hairCare'),
                                  child: containerService(
                                      context,
                                      'images/hair-gel.png',
                                      'Hair Care',
                                      size)),
                              SizedBox(width: size.width * 0.10),
                              InkWell(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/grooming'),
                                child: containerService(
                                    context,
                                    'images/hair-style.png',
                                    'Hair Styles',
                                    size),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                    // SliverGrid.count(
                    //   crossAxisCount: 2,
                    //   // mainAxisSpacing: 0.2,
                    //   // crossAxisSpacing: 15.0,
                    //   children: [

                    //   ],
                    // ),
                  ],
                  // slivers: [
                  //   SliverToBoxAdapter(
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //       child: Column(
                  //         children: [
                  //           Column(
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Text(
                  //                     "Hello,",
                  //                     style: TextStyle(fontSize: 22.0),
                  //                   )
                  //                 ],
                  //               ),
                  //               SizedBox(height: 5.0),
                  //               Row(
                  //                 children: [
                  //                   Text(
                  //                     snapshot.data!['FullName'],
                  //                     style: TextStyle(
                  //                       fontSize: 26.0,
                  //                       color: Theme.of(context).primaryColor,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //           Divider(
                  //             thickness: 1,
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  //   SliverPadding(
                  //     padding: const EdgeInsets.only(top: 30),
                  //   ),
                  //   SliverGrid.count(
                  //     crossAxisCount: 2,
                  //     mainAxisSpacing: 10.0,
                  //     crossAxisSpacing: 15,
                  //     children: [
                  //       InkWell(
                  //           onTap: () =>
                  //               Navigator.pushNamed(context, '/shaving'),
                  //           child: containerService(
                  //               context, 'images/razor.png', 'Shaving')),
                  //       InkWell(
                  //         onTap: () =>
                  //             Navigator.pushNamed(context, '/hairProducts'),
                  //         child: containerService(
                  //             context, 'images/shower.png', 'Hair Products'),
                  //       ),
                  //       InkWell(
                  //           onTap: () =>
                  //               Navigator.pushNamed(context, '/hairCare'),
                  //           child: containerService(
                  //               context, 'images/hair-gel.png', 'Hair Care')),
                  //       InkWell(
                  //         onTap: () =>
                  //             Navigator.pushNamed(context, '/grooming'),
                  //         child: containerService(
                  //             context, 'images/hair-style.png', 'Hair Styles'),
                  //       ),
                  //     ],
                  //   ),
                  //   SliverPadding(
                  //     padding: const EdgeInsets.only(top: 20),
                  //   ),
                  //   SliverToBoxAdapter(
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //       child: SizedBox(
                  //         height: MediaQuery.of(context).size.height / 10,
                  //         child: MaterialButton(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(15),
                  //           ),
                  //           color: Theme.of(context).cardColor,
                  //           onPressed: () =>
                  //               Navigator.pushNamed(context, '/reservations'),
                  //           child: Text(
                  //             'View Reservations',
                  //             style: TextStyle(
                  //               fontSize: 24.0,
                  //               fontWeight: FontWeight.w600,
                  //               color: Colors.grey,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //   SliverPadding(
                  //     padding: const EdgeInsets.only(top: 50),
                  //   ),
                  // ],
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

class RPSCustomPainter extends CustomPainter {
  final BuildContext context;

  RPSCustomPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Color.fromARGB(255, 4, 21, 34)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height * 0.0742857);
    path0.lineTo(0, size.height * 0.1457143);
    path0.lineTo(0, size.height * 0.2171429);
    path0.lineTo(0, size.height * 0.3585714);
    path0.lineTo(0, size.height * 0.5014286);
    path0.quadraticBezierTo(size.width * 0.0008333, size.height * 0.6107143, 0,
        size.height * 0.6471429);
    path0.quadraticBezierTo(size.width * 0.0077167, size.height * 0.7916714,
        size.width * 0.2508333, size.height * 0.7871429);
    path0.lineTo(size.width * 0.5000000, size.height * 0.7857143);
    path0.quadraticBezierTo(size.width * 0.6875000, size.height * 0.7857143,
        size.width * 0.7500000, size.height * 0.7857143);
    path0.quadraticBezierTo(size.width * 1.0262917, size.height * 0.7861714,
        size.width * 0.9991667, size.height * 0.9971429);
    path0.lineTo(size.width, size.height * 0.7185714);
    path0.lineTo(size.width * 0.9991667, size.height * 0.5728571);
    path0.lineTo(size.width, size.height * 0.3600000);
    path0.lineTo(size.width, size.height * 0.2157143);
    path0.lineTo(size.width, size.height * 0.0742857);
    path0.lineTo(size.width, 0);
    path0.lineTo(size.width * 0.8750000, 0);
    path0.lineTo(size.width * 0.7091667, 0);
    path0.lineTo(size.width * 0.5833333, 0);
    path0.lineTo(size.width * 0.5000000, 0);
    path0.lineTo(size.width * 0.3750000, 0);
    path0.lineTo(size.width * 0.2500000, 0);
    path0.lineTo(size.width * 0.1666667, 0);
    path0.lineTo(size.width * 0.0808333, 0);
    path0.lineTo(size.width * 0.0400000, 0);
    path0.lineTo(0, 0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
