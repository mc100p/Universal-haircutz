import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universalhaircutz/utils/widget.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

getToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  print('token: ' + token!);
  return token;
}

getCurrentUser() async {
  final User user = _auth.currentUser!;
  return user.uid;
}

Future<String> getCurrentUID() async {
  return (_auth.currentUser!).uid;
}

class AuthService {
  //SIGN UP NEW USER............................................
  Future signUp(
      BuildContext context,
      String email,
      String name,
      String password,
      String address,
      String token,
      VoidCallback callBack) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;
      var uid = await getCurrentUser();
      var date = DateTime.now();
      String blankPhoto =
          'https://firebasestorage.googleapis.com/v0/b/universal-haircutz.appspot.com/o/user.png?alt=media&token=efa0599f-3c2c-479c-9242-fa6abd5231ce';
      String path = '';
      String role = "User";

      var usersObject = {
        'FullName': name,
        'token': token,
        'email': email,
        'address': address,
        'imgUrl': blankPhoto,
        'uid': uid,
        'path': path,
        'date': date,
        'role': role,
      };

      var userInformationObject = {
        'FullName': name,
        'email': email,
        'token': token,
        'Date': date,
      };

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .set(usersObject);

      await FirebaseFirestore.instance
          .collection('userInformation')
          .doc(user.uid)
          .collection("users")
          .add(userInformationObject);

      await result.user!.updateDisplayName(name);
      await result.user!.updateEmail(email);
      await result.user!.updatePhotoURL(blankPhoto);
      await result.user!.reload();
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sign Up Successful", style: TextStyle(color: Colors.white)),
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              )
            ],
          ),
          Colors.green);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } on FirebaseException catch (e) {
      callBack();
      var error = e.message.toString().replaceAll(
          'com.google.firebase.FirebaseException: An internal error has' +
              ' occurred. [ Unable to resolve host "www.googleapis.com":' +
              "No address associated with hostname ]",
          "Please Check Network Connection");

      if (e.message.toString() ==
          "The email address is already in use by another account.") {
        Navigator.pop(context);
      }

      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  child: Text("$error", style: TextStyle(color: Colors.white))),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e.toString());
      return null;
    }
  }

  //LOGIN USER............................................................

  Future signIn(BuildContext context, String email, String password,
      String token, VoidCallback callBack) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());

      token = await getToken();
      print('token from sign up: $token');

      var date = DateTime.now();

      var userTokenDataObject = {
        'Email': email,
        'Token': token,
        'Date': date,
      };

      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      var hashedPassword = new DBCrypt().hashpw(password, DBCrypt().gensalt());

      print('password: $hashedPassword');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      prefs.setString('password', hashedPassword);

      await FirebaseFirestore.instance
          .collection('Users Token Data')
          .doc(result.user!.uid)
          .set(userTokenDataObject);

      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(result.user!.uid)
          .get();

      String role = snapshot['role'];

      print("role: " + role);

      FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: result.user!.uid)
          .get()
          .then(
        (value) {
          if (role.isNotEmpty) {
            if (role == 'User') {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/userHomePage', (Route<dynamic> route) => false);
            } else if (role == 'Admin') {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/adminHomePage', (Route<dynamic> route) => false);
            }
          }
        },
      );

      prefs.setString('role', role);
    } on FirebaseException catch (e) {
      callBack();
      var error = e.message.toString();

      var snackBar = snackBarWidget(
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                child: Text(
                  "$error",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              ),
            ],
          ),
          Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(error);
      return null;
    }
  }

  //RESET USER'S PASSWORD.......................................................

  Future reset(
      BuildContext context, String email, void Function() callBack) async {
    try {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) => print("Check your email"));
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Check your email to reset password",
                  style: TextStyle(color: Colors.white)),
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              )
            ],
          ),
          Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pushNamedAndRemoveUntil(context, '/login', (e) => false);
    } catch (e) {
      var error = e.toString();
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$error", style: TextStyle(color: Colors.white)),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print("$error");
      print("Failed to reset password");
    }
  }

  //SIGN OUT.................................................................
  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      SharedPreferences prfs = await SharedPreferences.getInstance();
      prfs.remove('email');
      prfs.remove('password');
      prfs.remove('role');
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (Route<dynamic> route) => false);
    } catch (e) {
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Failed to sign out",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e.toString());
      return null;
    }
  }
}
