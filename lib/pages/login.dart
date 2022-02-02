import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universalhaircutz/services/auth.dart';
import 'package:universalhaircutz/utils/widget.dart';

class Login extends StatefulWidget {
  @override
  State createState() => new LoginState();
}

class LoginState extends State<Login> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String? _token;
  String _errorMessage = '';
  bool _obscureText = true;
  bool isloading = false;

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    _token = getToken().toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(alignment: Alignment.center, children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.20),
                new Form(
                  key: _formkey,
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            new TextFormField(
                              decoration: textFieldInputDecoration(
                                context,
                                "Enter Your Email",
                              ),
                              validator: (value) =>
                                  value!.isEmpty || !value.contains("@")
                                      ? 'Enter valid email'
                                      : null,
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 15.0),
                            new TextFormField(
                              decoration:
                                  textFieldInputDecorationForLoginPagePassword(
                                context,
                                "Enter Password",
                                IconButton(
                                  iconSize: 28,
                                  color: Theme.of(context).primaryColor,
                                  icon: Icon(_obscureText
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility),
                                  onPressed: () {
                                    _toggle();
                                  },
                                ),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Check Password' : null,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscureText,
                              controller: _password,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/resetPassword');
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontFamily: 'PlayfairDisplay-Regular',
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            new Padding(
                                padding: const EdgeInsets.only(top: 40.0)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: isloading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      ),
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: new MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        child: new Text("Login",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () async {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            setState(
                                              () => isloading = true,
                                            );

                                            void callBack() {
                                              setState(() {
                                                isloading = false;
                                              });
                                            }

                                            dynamic result = AuthService()
                                                .signIn(
                                                    context,
                                                    _email.text.trim(),
                                                    _password.text.trim(),
                                                    _token!,
                                                    callBack);

                                            if (result == null) {
                                              setState(() => isloading = false);
                                            }
                                          }
                                        },
                                        splashColor: Colors.white,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'PlayfairDisplay',
                                        fontSize: 18.0),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/signUp');
                                    },
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                        fontFamily: 'PlayfairDisplay - Regular',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                _errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
