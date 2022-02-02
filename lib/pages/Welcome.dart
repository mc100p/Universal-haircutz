import 'package:flutter/material.dart';
import 'package:universalhaircutz/utils/widget.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  late Animation titleAnimation,
      titleAnimationB,
      bodyAnimationMove,
      bodyAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    titleAnimation =
        Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceIn,
    ));
    bodyAnimation = Tween<double>(begin: 2.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1, curve: Curves.elasticOut)));

    titleAnimationB = Tween<double>(begin: 2.55, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.3, 1, curve: Curves.elasticOut)));

    bodyAnimationMove =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(0.4, 1, curve: Curves.elasticOut),
    ));
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              BackgroundImage(),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Center(
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, bodyAnimation.value * width, 0.0),
                          child: Image.asset("images/logo.png",
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.height * 0.35),
                        ),
                      ),
                      Transform(
                        transform: Matrix4.translationValues(
                            0.0, bodyAnimation.value * width, 0.0),
                        child: Container(
                          height: 100.0,
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),

                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10),
                      // SizedBox(height: MediaQuery.of(context).size.height / 3),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, bodyAnimationMove.value * width, 0.0),
                          child: MaterialButton(
                            elevation: 17.0,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login', (Route<dynamic> route) => false);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Get a stylish haircut",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Wrap(
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(
                                  0.0, titleAnimationB.value * width, 0.0),
                              child: Text(
                                "Welcome to Universal Haircutz",
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
