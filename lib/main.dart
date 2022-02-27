import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universalhaircutz/pages/AdminHomePage.dart';
import 'package:universalhaircutz/pages/Welcome.dart';
import 'package:universalhaircutz/pages/homepage/homepage.dart';
import 'package:universalhaircutz/utils/provider.dart';
import 'package:universalhaircutz/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:universalhaircutz/utils/theme.dart';

Future<void> main() async {
  final title = 'Universal Haircutz';
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessaginBackgroundHandler);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  String? login = prefs.getString('email');
  String? role = prefs.getString('role');

  print("login: " + login.toString());
  print("role: " + role.toString());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          Provider<SharedPreferencesProvider>(
            create: (_) => SharedPreferencesProvider(prefs),
          ),
        ],
        child: MyApp(
          login: login,
          title: title,
          role: role,
        ),
      ),
    ),
  );
}

Future<void> _firebaseMessaginBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notifications',
//   // 'This channel is used for important notifications',
//   importance: Importance.high,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.login,
    required this.title,
    required this.role,
  }) : super(key: key);

  final String? login;
  final String title;
  final String? role;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.black87,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarColor: Colors.black,
          ),
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          initialRoute: "/",
          onGenerateRoute: RouteGenerator.generateRoute,
          // theme: ThemeData(
          //   primaryColor: Color(0xFFFC9900),
          // ),
          home: getState(login),
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
        );
      },
    );
  }

  Widget getState(value) {
    if (login != null) {
      if (role == "User") {
        value = MyHomePage();
      } else if (role == "Admin") {
        value = AdminHomePage();
      }
    } else {
      value = Welcome();
    }
    return value;
  }
}
