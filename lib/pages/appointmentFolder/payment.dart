import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckOutDialog extends StatefulWidget {
  @override
  _CheckOutDialogState createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PageController? pageController;

  String _errorMessage = '';

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "Enter Card Information",
                      style: TextStyle(
                          fontSize: 20.0, fontFamily: 'PlayfairDisplay'),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(height: 10.0),
                    Form(
                      key: _formKey,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(10.0))),
                                      hintText: "1234-5478-9876-5432",
                                      hintStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter your card details'
                                      : null,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 50,
                                height: MediaQuery.of(context).size.height / 15,
                                child: isloading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        ),
                                      )
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: MaterialButton(
                                          onPressed: confirm,
                                          color: Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          child: new Text(
                                            "Pay Now",
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          splashColor: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Divider(
                              thickness: 3,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  void confirm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/userHomePage', (Route<dynamic> route) => false);
        Fluttertoast.showToast(
          msg:
              "We will validate this transaction then send you an Order ID shortly.",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey[700],
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );
      } catch (e) {
        setState(() {
          isloading = false;
          _errorMessage = e.toString();
        });
        print(e);
      }
    }
  }
}
