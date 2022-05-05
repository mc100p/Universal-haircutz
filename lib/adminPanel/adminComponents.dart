import 'package:flutter/material.dart';
import 'package:universalhaircutz/services/auth.dart';

class AdminDrawerClass extends StatelessWidget {
  const AdminDrawerClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
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
    );
  }
}
