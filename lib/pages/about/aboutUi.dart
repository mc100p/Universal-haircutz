import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/pages/about/aboutComponents.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                Header(),
                SizedBox(height: size.height * 0.05),
                subHeader('More Than a Great Haircut and Shave'),
                SizedBox(height: size.height * 0.05),
                AboutDetails(size: size),
                SizedBox(height: size.height * 0.05),
                subHeader('Hours of Operation'),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
          createDataTable(),
          SizedBox(height: size.height * 0.10),
        ],
      ),
    );
  }
}
