import 'package:flutter/material.dart';
import 'package:universalhaircutz/pages/AdminHomePage.dart';
import 'package:universalhaircutz/pages/appointment.dart';
import 'package:universalhaircutz/pages/appointmentDetails.dart';
import 'package:universalhaircutz/pages/beardTriming.dart';
import 'package:universalhaircutz/pages/forgotPassword.dart';
import 'package:universalhaircutz/pages/hairCare.dart';
import 'package:universalhaircutz/pages/hairWarmming.dart';
import 'package:universalhaircutz/pages/homepage.dart';
import 'package:universalhaircutz/pages/login.dart';
import 'package:universalhaircutz/pages/register.dart';
import 'package:universalhaircutz/pages/settings.dart';
import 'package:universalhaircutz/pages/shaving.dart';
import 'package:universalhaircutz/utils/widget.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      //PAGES SHARED BY BOTH ADMIN AND USERS

      // case '/introScreen':
      //   return MaterialPageRoute(builder: (context) => IntroScreen());

      //PAGES UNIQUE TO ADMIN

      case '/adminHomePage':
        return MaterialPageRoute(builder: (context) => AdminHomePage());

      // case '/adminProfilePage':
      //   return MaterialPageRoute(builder: (context) => UserProfile());
      case '/hairWarmming':
        return MaterialPageRoute(builder: (context) => HairWarming());

      case '/hairCare':
        return MaterialPageRoute(builder: (context) => HairCare());

      case '/grooming':
        return MaterialPageRoute(builder: (context) => BeardTriming());

      case '/shaving':
        return MaterialPageRoute(builder: (context) => Shaving());

      //PAGES UNIQUE TO USERS

      case '/settings':
        return MaterialPageRoute(builder: (context) => Settings());

      case '/signUp':
        return MaterialPageRoute(builder: (context) => SignUp());

      case '/userHomePage':
        return MaterialPageRoute(builder: (context) => MyHomePage());

      case '/resetPassword':
        return MaterialPageRoute(builder: (context) => PasswordReset());

      case '/login':
        return MaterialPageRoute(builder: (context) => Login());

      // case '/finance':
      //   return MaterialPageRoute(builder: (context) => Finance());

      // case '/userProfile':
      //   return MaterialPageRoute(builder: (context) => Profile());

      // case '/appointment':
      //   return MaterialPageRoute(builder: (context) => Appointment());

      // case '/feedBack':
      //   return MaterialPageRoute(builder: (context) => FeedBackHelp());

      // case '/history':
      //   return MaterialPageRoute(builder: (context) => History());

      // case '/achievement':
      //   return MaterialPageRoute(builder: (context) => Achievement());

      // case '/cart':
      //   return MaterialPageRoute(builder: (context) => Cart());

      // case '/qr':
      //   return MaterialPageRoute(builder: (context) => Qr());

      case '/appointment':
        AppointmentDetails args = settings.arguments as AppointmentDetails;
        return MaterialPageRoute(
          builder: (context) => AppointmentDetails(
            heroTag: args.heroTag,
            name: args.name,
            cost: args.cost,
          ),
        );

      case '/appointmentDetails':
        AppointmentSetUp args = settings.arguments as AppointmentSetUp;
        return MaterialPageRoute(
          builder: (context) => AppointmentSetUp(
            heroTag: args.heroTag,
            name: args.name,
            price: args.price,
            barberEmail: args.barberEmail,
            barberName: args.barberName,
            barberImage: args.barberImage,
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (BuildContext builder) {
        return Scaffold(
          appBar: appBar(builder, "Error 404"),
          body: Center(
            child: Text("Page not found....."),
          ),
        );
      },
    );
  }
}
