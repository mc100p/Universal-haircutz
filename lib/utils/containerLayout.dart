import 'package:flutter/material.dart';

Widget containerService(
    BuildContext context, String image, String text, Size size) {
  return Column(
    children: [
      SizedBox(
        height: size.height * 0.20,
        width: size.width * 0.30,
        child: Card(
          color: Color.fromARGB(255, 4, 21, 34),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Image(
              image: AssetImage('$image'),
              color: Colors.white,
            ),
          ),
        ),
      ),
      Text(
        '$text',
        style: TextStyle(fontSize: 12.0),
      ),
    ],
  );
}
