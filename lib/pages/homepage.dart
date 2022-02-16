import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/services/auth.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: ListView(
            children: [
              ListTile(
                title: Text("Settings"),
                onTap: () => Navigator.popAndPushNamed(context, '/settings'),
                trailing: Icon(Icons.settings),
              ),
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () async {
                  AuthService().signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
      // extendBodyBehindAppBar: true,
      // extendBody: true,
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
                                'images/razor.png', 'Shaving')),
                        containerService(
                            'images/blow-dryer.png', 'Hair warming'),
                        containerService('images/shower.png', 'Hair Care'),
                        containerService(
                            'images/beard-trimming.png', 'Beard Triming'),
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
                            onPressed: () {},
                            child: Text(
                              'Reservation Now',
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

  Widget containerService(String image, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 20,
        width: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('$image'),
              height: 80,
              width: 80,
            ),
            SizedBox(height: 20),
            Text(
              '$text',
              style: TextStyle(color: Colors.grey, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
