import 'package:flutter/material.dart';
import 'package:universalhaircutz/pages/adminPanel/AdminHomePage.dart';
import 'package:universalhaircutz/pages/about/about.dart';
import 'package:universalhaircutz/pages/adminPanel/adminRervations.dart';
import 'package:universalhaircutz/pages/appointment.dart';
import 'package:universalhaircutz/pages/appointmentFolder/appointmentDetails.dart';
import 'package:universalhaircutz/pages/feedBack/feedback.dart';
import 'package:universalhaircutz/pages/hairProducts/cart.dart';
import 'package:universalhaircutz/pages/hairProducts/hairProdDetails.dart';
import 'package:universalhaircutz/pages/hairProducts/hairProducts.dart';
import 'package:universalhaircutz/pages/hairStyle.dart';
import 'package:universalhaircutz/pages/forgotPassword.dart';
import 'package:universalhaircutz/pages/hairCare.dart';
import 'package:universalhaircutz/pages/homepage/homepage.dart';
import 'package:universalhaircutz/pages/location/location.dart';
import 'package:universalhaircutz/pages/login.dart';
import 'package:universalhaircutz/pages/register.dart';
import 'package:universalhaircutz/pages/reservations/reservation.dart';
import 'package:universalhaircutz/pages/settings.dart';
import 'package:universalhaircutz/pages/shaving.dart';
import 'package:universalhaircutz/pages/termsConditions/terms.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/cart':
        return MaterialPageRoute(builder: (context) => Cart());

      case '/location':
        return MaterialPageRoute(builder: (context) => Location());

      case '/feedBack':
        return MaterialPageRoute(builder: (context) => FeedBackHelp());

      case '/adminHomePage':
        return MaterialPageRoute(builder: (context) => AdminHomePage());

      case '/hairProducts':
        return MaterialPageRoute(builder: (context) => HairProducts());

      case '/hairCare':
        return MaterialPageRoute(builder: (context) => HairCare());

      case '/grooming':
        return MaterialPageRoute(builder: (context) => HairStyle());

      case '/termsAndConditions':
        return MaterialPageRoute(builder: (context) => Terms());

      case '/shaving':
        return MaterialPageRoute(builder: (context) => Shaving());

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

      case '/reservations':
        return MaterialPageRoute(builder: (context) => Appointment());

      case '/about':
        return MaterialPageRoute(builder: (context) => About());

      case '/adminReservations':
        return MaterialPageRoute(builder: (context) => AdminReservations());

      case '/appointment':
        AppointmentDetails args = settings.arguments as AppointmentDetails;
        return MaterialPageRoute(
          builder: (context) => AppointmentDetails(
            heroTag: args.heroTag,
            name: args.name,
            cost: args.cost,
          ),
        );

      case '/hairProductDetails':
        HairProductsDetails args = settings.arguments as HairProductsDetails;
        return MaterialPageRoute(
          builder: (context) => HairProductsDetails(
            directions: args.directions,
            heroTag: args.heroTag,
            inactiveIngredients: args.inactiveIngredients,
            name: args.name,
            price: args.price,
            uses: args.uses,
            warnings: args.warnings,
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
          appBar: AppBar(title: Text("Error 404")),
          body: Center(
            child: Text("Page not found....."),
          ),
        );
      },
    );
  }
}
