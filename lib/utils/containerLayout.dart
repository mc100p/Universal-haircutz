import 'package:flutter/material.dart';

Widget containerService(BuildContext context, String image, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 20,
      width: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('$image'),
            height: 50,
            width: 50,
          ),
          SizedBox(height: 20),
          Text(
            '$text',
            style: TextStyle(color: Colors.grey, fontSize: 18.0),
          ),
        ],
      ),
    ),
  );
}
