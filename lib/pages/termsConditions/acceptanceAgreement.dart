import 'package:flutter/material.dart';
import 'package:universalhaircutz/models/termsModel.dart';

class AcceptanceAgreement extends StatelessWidget {
  const AcceptanceAgreement({
    Key? key,
    required this.achievement,
    required this.size,
  }) : super(key: key);

  final TermsData achievement;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "ACCEPTANCE AND AGREEMENT",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          achievement.terms2,
          style: TextStyle(
            fontSize: 11.0,
          ),
        ),
      ],
    );
  }
}
