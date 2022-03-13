import 'package:flutter/material.dart';

SnackBar snackBarWidget(Widget content, Color color) {
  return SnackBar(content: content, backgroundColor: color);
}

AppBar appBarWithOption(BuildContext context, String title, actions) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    title: Text(
      title,
      style: TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.white),
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: () => Navigator.pop(context),
    ),
    elevation: 0.0,
    actions: actions,
    centerTitle: true,
  );
}

InputDecoration textFieldInputDecoration(
    BuildContext context, String labelText) {
  return InputDecoration(
    hintText: labelText,
    border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.white),
    ),
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(
      fontFamily: 'PlayfairDisplay-Regular',
      fontSize: 15.0,
      color: Colors.black,
    ),
    focusColor: Theme.of(context).primaryColor,
  );
}

InputDecoration textFieldInputDecorationForLoginPagePassword(
    BuildContext context, String labelText, IconButton suffixIcon) {
  return InputDecoration(
    border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.white),
    ),
    suffixIcon: suffixIcon,
    focusColor: Theme.of(context).primaryColor,
    hintText: labelText,
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(
      fontFamily: 'PlayfairDisplay-Regular',
      fontSize: 15.0,
      color: Colors.black,
    ),
  );
}

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(Colors.black45, BlendMode.darken),
          image: AssetImage("images/barberChair.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

SnackBar successDisplay(String success) {
  return SnackBar(
    backgroundColor: Colors.green,
    content: Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        Text(
          "$success",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Arial',
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: Colors.white,
        )
      ],
    ),
  );
}

SnackBar errorDisplay(String error) {
  return SnackBar(
    backgroundColor: Colors.red,
    content: Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        Text("$error",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Arial',
            )),
        Icon(
          Icons.error_outline_sharp,
          color: Colors.white,
        )
      ],
    ),
  );
}
