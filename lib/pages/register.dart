import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/services/auth.dart';
import 'package:universalhaircutz/utils/widget.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  ]);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  TextEditingController _email = TextEditingController();
  TextEditingController _fullname = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _address = TextEditingController();
  bool isloading = false;
  bool _obscureText = true;
  String _token = '';

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
    return Stack(
      alignment: Alignment.center,
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            // reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        iconSize: 40.0,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Text(
                    "Fill out Registration Form",
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay-Regular',
                      color: Colors.white,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  endIndent: 50,
                  indent: 50,
                ),
                new Form(
                  key: _formKey,
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            new TextFormField(
                              decoration: textFieldInputDecoration(
                                  context, "Enter Your Full Name"),
                              validator: (value) => value!.isEmpty
                                  ? 'Name Cannot be empty'
                                  : null,
                              controller: _fullname,
                              // onSaved: (value) => _fullname = value!.trim(),
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 15.0),
                            new TextFormField(
                              decoration: textFieldInputDecoration(
                                  context, "Enter Your Email Address:"),
                              validator: (value) =>
                                  value!.isEmpty || !value.contains("@")
                                      ? 'Enter a valid email address'
                                      : null,
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 15.0),
                            new TextFormField(
                              decoration: textFieldInputDecoration(
                                  context, "Enter Your Address:"),
                              validator: (value) => value!.isEmpty
                                  ? 'Enter a valid address'
                                  : null,
                              controller: _address,
                              keyboardType: TextInputType.name,
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
                              validator: passwordValidator,
                              controller: _password,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscureText,
                            ),
                            SizedBox(height: 15.0),
                            new TextFormField(
                              decoration:
                                  textFieldInputDecorationForLoginPagePassword(
                                context,
                                "Confirm Password",
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
                              validator: (value) => MatchValidator(
                                      errorText: 'Passwords do not match')
                                  .validateMatch(value!, _password.text),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscureText,
                            ),
                            new Padding(
                                padding: const EdgeInsets.only(top: 30.0)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 90.0),
                              child: isloading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
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
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (mounted) {
                                              setState(() => isloading = true);
                                            }

                                            try {
                                              EmailAuth emailAuth = EmailAuth(
                                                  sessionName:
                                                      "Universal Haircutz");

                                              await emailAuth.sendOtp(
                                                  recipientMail:
                                                      _email.text.trim());

                                              var snackBar = snackBarWidget(
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Check your email",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .check_circle_rounded,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  ),
                                                  Colors.green);

                                              if (mounted)
                                                setState(() {
                                                  isloading = false;
                                                });

                                              void callBack() {
                                                setState(() {
                                                  isloading = false;
                                                });
                                              }

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);

                                              showDialog(
                                                  context: context,
                                                  builder: (builder) {
                                                    return VerifyEmail(
                                                      email: _email,
                                                      fullName: _fullname,
                                                      password: _password,
                                                      token: _token,
                                                      address: _address,
                                                      callback: callBack,
                                                    );
                                                  });
                                            } catch (e) {
                                              var snackBar = snackBarWidget(
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.80,
                                                        ),
                                                        child: Text(
                                                          "Failed to send OTP code, try again later",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .error_outline_sharp,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  ),
                                                  Colors.red);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }
                                        },
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        child: new Text("Sign Up",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        splashColor: Colors.white,
                                      ),
                                    ),
                            ),
                            Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
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
      ],
    );
  }
}

// ignore: must_be_immutable
class VerifyEmail extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController fullName;
  final TextEditingController password;
  final TextEditingController address;
  final VoidCallback callback;
  String token = '';
  VerifyEmail({
    Key? key,
    required this.email,
    required this.fullName,
    required this.password,
    required this.token,
    required this.address,
    required this.callback,
  }) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  TextEditingController userOtp = TextEditingController();
  final AuthService _firebaseAuth = AuthService();
  bool sendVerification = false;
  bool resendVerification = false;
  GlobalKey<FormState> _verifyFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100.0),
            Text(
              "OTP Verification",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14.0),
            Text(
              "An email has been sent to",
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              "${this.widget.email.text}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't get a code?"),
                  resendVerification
                      ? Center(
                          child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : TextButton(
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () => resendOTP(),
                        )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _verifyFormKey,
                child: TextFormField(
                  decoration: textFieldInputDecoration(
                      context, "Enter Verification Code"),
                  controller: userOtp,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter OTP code' : null,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width - 50,
                  child: sendVerification
                      ? Center(child: CircularProgressIndicator())
                      : MaterialButton(
                          child: Text(
                            "Proceed",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_verifyFormKey.currentState!.validate()) {
                              verifyOTP();
                            }
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyOTP() async {
    EmailAuth emailAuth = EmailAuth(sessionName: "Universal Haircutz");

    var res = emailAuth.validateOtp(
        recipientMail: this.widget.email.text, userOtp: userOtp.text.trim());
    if (res) {
      print("OTP Verified");
      if (mounted)
        setState(() {
          sendVerification = true;
        });
      dynamic result = await _firebaseAuth.signUp(
        context,
        this.widget.email.text.trim(),
        this.widget.fullName.text.trim(),
        this.widget.password.text.trim(),
        this.widget.address.text.trim(),
        this.widget.token,
        this.widget.callback,
      );

      if (result == null) {
        if (mounted)
          setState(() {
            sendVerification = false;
          });
      }
    } else {
      print("Otp failed");

      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                child: Text(
                  "OTP Verification code incorrect",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> resendOTP() async {
    try {
      if (mounted)
        setState(() {
          resendVerification = true;
        });

      EmailAuth emailAuth = EmailAuth(sessionName: "Universal Haircutz");

      await emailAuth.sendOtp(recipientMail: this.widget.email.text.trim());

      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Check your email",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              )
            ],
          ),
          Colors.green);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (mounted)
        setState(() {
          resendVerification = false;
        });
    } catch (e) {
      this.widget.callback();
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                child: Text(
                  "Failed to send OTP code, try again later",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
