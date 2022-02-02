import 'package:flutter/material.dart';
import 'package:universalhaircutz/pages/AdminHomePage.dart';
import 'package:universalhaircutz/pages/forgotPassword.dart';
import 'package:universalhaircutz/pages/homepage.dart';
import 'package:universalhaircutz/pages/login.dart';
import 'package:universalhaircutz/pages/register.dart';
import 'package:universalhaircutz/pages/settings.dart';
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
      // case '/adminSettings':
      //   return MaterialPageRoute(builder: (context) => AdminSettings());

      // case '/addUser':
      //   return MaterialPageRoute(builder: (context) => AddUser());

      // case '/viewAppointments':
      //   return MaterialPageRoute(builder: (context) => ViewAppointments());

      // case '/prescription':
      //   return MaterialPageRoute(builder: (context) => Prescription());

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

      // case '/doctorDetails':
      //   DoctorDetail args = settings.arguments as DoctorDetail;
      //   return MaterialPageRoute(
      //     builder: (context) => DoctorDetail(
      //         heroTag: args.heroTag,
      //         identification: args.identification,
      //         occupation: args.occupation,
      //         description: args.description,
      //         email: args.email),
      //   );

      // case '/medicationDetails':
      //   MedicationDetails args = settings.arguments as MedicationDetails;
      //   return MaterialPageRoute(
      //     builder: (context) => MedicationDetails(
      //       directions: args.directions,
      //       heroTag: args.heroTag,
      //       inactiveIngredients: args.inactiveIngredients,
      //       medicationName: args.medicationName,
      //       price: args.price,
      //       uses: args.uses,
      //       warnings: args.warnings,
      //     ),
      //   );
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
