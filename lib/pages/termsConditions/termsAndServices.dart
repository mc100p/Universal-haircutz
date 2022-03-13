import 'package:flutter/material.dart';
import 'package:universalhaircutz/models/termsModel.dart';

class TermsandServices extends StatelessWidget {
  const TermsandServices({
    Key? key,
    required this.size,
    required this.achievement,
  }) : super(key: key);

  final Size size;
  final TermsData achievement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "TERMS AND SERVICES",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          achievement.terms1,
          style: TextStyle(
            fontSize: 11.0,
          ),
        ),
      ],
    );
  }
}
