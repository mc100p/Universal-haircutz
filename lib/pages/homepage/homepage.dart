import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/pages/drawer/drawer.dart';
import 'package:universalhaircutz/pages/homepage/containerLayout.dart';
import 'package:universalhaircutz/services/auth.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerClass(),
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
                        InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/shaving'),
                            child: containerService(
                                context, 'images/razor.png', 'Shaving')),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/hairWarmming'),
                          child: containerService(
                              context, 'images/blow-dryer.png', 'Hair warming'),
                        ),
                        InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/hairCare'),
                            child: containerService(
                                context, 'images/shower.png', 'Hair Care')),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/grooming'),
                          child: containerService(
                              context, 'images/hair-style.png', 'Hair Styles'),
                        ),
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
                            onPressed: () =>
                                Navigator.pushNamed(context, '/reservations'),
                            child: Text(
                              'View Reservations',
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
