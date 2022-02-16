import 'package:flutter/material.dart';
import 'package:universalhaircutz/services/auth.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Text("Admin Panel"),
      ),
    );
  }
}
