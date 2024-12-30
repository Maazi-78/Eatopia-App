import 'package:eatopia/pages/Restaurant/res_home.dart';
import 'package:eatopia/pages/loading.dart';
import 'package:eatopia/pages/login.dart';
import 'package:eatopia/pages/user_sign_up.dart';
import 'package:eatopia/services/maps.dart';
import 'package:eatopia/pages/buisness_sign_up.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:eatopia/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'pages/Customer/about_us.dart';
import 'pages/Customer/user_home.dart';
import 'pages/Customer/user_profile.dart';
import 'pages/welcome_page.dart';
import 'pages/Customer/Terms_policy.dart';
import 'package:eatopia/pages/Restaurant/res_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/UserSignUpPageOne': (context) => const UserSignUpPageOne(),
        '/UserSignUpPageTwo': (context) => const UserSignUpPageTwo(),
        '/WelcomePage': (context) => const WelcomePage(),
        '/MapScreen': (context) => const MapScreen(),
        '/UserHomePage': (context) => const UserHomePage(),
        '/LoginPage': (context) => const LoginPage(),
        '/BuisnessSignup': (context) => const BuisnessSignup(),
        '/ResHomePage': (context) => const ResHome(),
        '/User_profile': (context) => const UserProfile(),
        '/Terms_policy': (context) => const Terms_policy(),
        '/About_us': (context) => const About_us(),
        '/Res_profile': (context) => const ResProfile(),
      },
      theme: ThemeData(
        fontFamily: 'ubuntu',
        primarySwatch: MaterialColor(0xFF016D39, {
          50: appGreen,
          100: appGreen,
          200: appGreen,
          300: appGreen,
          400: appGreen,
          500: appGreen,
          600: appGreen,
          700: appGreen,
          800: appGreen,
          900: appGreen,
        }),
      ),
    );
  }
}
