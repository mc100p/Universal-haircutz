import 'package:flutter/material.dart';
import 'package:universalhaircutz/services/auth.dart';

class DrawerClass extends StatelessWidget {
  const DrawerClass({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Universal Hair Cutz',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22.0,
                  ),
                ),
              ),
              Divider(thickness: 1),
              SizedBox(height: size.height * 0.06),
              ListTile(
                title: Text("About"),
                onTap: () => Navigator.popAndPushNamed(context, '/about'),
                trailing: Icon(Icons.info_outline),
              ),
              ListTile(
                title: Text("Location"),
                onTap: () => Navigator.popAndPushNamed(context, '/location'),
                trailing: Icon(Icons.location_on),
              ),
              ListTile(
                title: Text('Allergies Update'),
                onTap: () => Navigator.popAndPushNamed(context, '/allergies'),
                trailing: Icon(Icons.sick),
              ),
              Seperator(),
              ListTile(
                title: Text("Feed back"),
                onTap: () => Navigator.popAndPushNamed(context, '/feedBack'),
                trailing: Icon(Icons.help),
              ),
              ListTile(
                title: Text("Settings"),
                onTap: () => Navigator.popAndPushNamed(context, '/settings'),
                trailing: Icon(Icons.settings),
              ),
              ListTile(
                title: Text("Terms and Condtions"),
                onTap: () =>
                    Navigator.popAndPushNamed(context, '/termsAndConditions'),
                trailing: Icon(Icons.privacy_tip_outlined),
              ),
              Seperator(),
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

class Seperator extends StatelessWidget {
  const Seperator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        "..........................................................................................",
        maxLines: 1);
  }
}
