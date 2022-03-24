import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(
    BuildContext context, String labelText) {
  return InputDecoration(
    labelText: labelText,
    border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.white),
    ),
    // fillColor: Colors.white,
    // filled: true,
    labelStyle: TextStyle(
      fontFamily: 'PlayfairDisplay-Regular',
      fontSize: 15.0,
      color: Colors.black,
    ),
    focusColor: Theme.of(context).primaryColor,
  );
}
