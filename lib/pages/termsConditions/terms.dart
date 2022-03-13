import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universalhaircutz/models/termsModel.dart';
import 'package:universalhaircutz/pages/termsConditions/acceptanceAgreement.dart';
import 'package:universalhaircutz/pages/termsConditions/privacyPolicy.dart';
import 'package:universalhaircutz/pages/termsConditions/termsAndServices.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scrollControll = ScrollController();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Terms').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.data!.docs.isEmpty)
                return Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 50.0),
                          Center(
                            child: Text("Opps!!!! an error has occured"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              return Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot keyword = snapshot.data!.docs[index];
                    TermsData achievement = TermsData.fromJson(
                        keyword.data()! as Map<String, dynamic>);

                    return Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(75))),
                          child: ClipPath(
                            clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(75),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: size.height * 0.06),
                                  TermsandServices(
                                      size: size, achievement: achievement),
                                  SizedBox(height: size.height * 0.06),
                                  AcceptanceAgreement(
                                      size: size, achievement: achievement),
                                  SizedBox(height: size.height * 0.06),
                                  PrivacyPolicy(
                                      size: size, achievement: achievement),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
