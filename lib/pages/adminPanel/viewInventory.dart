import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/utils/widget.dart';

class ViewInventory extends StatefulWidget {
  const ViewInventory({
    Key? key,
    required this.uid,
    required this.encrpytedPassword,
  }) : super(key: key);

  final uid;
  final encrpytedPassword;

  @override
  State<ViewInventory> createState() => _ViewInventoryState();
}

class _ViewInventoryState extends State<ViewInventory> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController confirmPasswordController = TextEditingController();
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return SliverToBoxAdapter(
      child: widget.uid == 'kFVvFUFyEtQyaS7bQ45x9Bsl38v2'
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Theme.of(context).cardColor,
                  onPressed: () {
                    openDialog(context, _formkey, confirmPasswordController);
                  },
                  child: Text(
                    'View Inventory',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Future<dynamic> openDialog(
      BuildContext context,
      GlobalKey<FormState> _formkey,
      TextEditingController confirmPasswordController) {
    return showDialog(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: SingleChildScrollView(
                child: Text('Enter password to navigate to inventory'),
              ),
              content: Form(
                key: _formkey,
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: textFieldInputDecorationForLoginPagePassword(
                    context,
                    'Enter Password',
                    IconButton(
                      iconSize: 28,
                      color: Theme.of(context).primaryColor,
                      icon: Icon(_obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility),
                      onPressed: () {
                        // _toggle();
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  controller: confirmPasswordController,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter password' : null,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('No')),
                TextButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        var isCorrect = new DBCrypt().checkpw(
                            confirmPasswordController.text.trim(),
                            this.widget.encrpytedPassword);

                        if (isCorrect == true) {
                          Navigator.popAndPushNamed(context, '/inventory');
                        } else {
                          Navigator.pop(context);
                          var snackBar = snackBarWidget(
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.80,
                                    ),
                                    child: Text(
                                      "Incorrect Password",
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
                        }
                        // if (DBCrypt().checkpw(
                        //     confirmPasswordController.text,
                        //     this.widget.encrpytedPassword)) {
                        //   print('correct');
                        // }
                      }
                    },
                    child: Text('Proceed')),
              ],
            ),
          );
        });
  }
}
