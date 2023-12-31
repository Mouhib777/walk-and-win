import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:walk_and_win/constant/constant.dart';
import 'package:walk_and_win/firebase_options.dart';
import 'package:walk_and_win/screens/register-login/login.dart';
import 'package:walk_and_win/screens/register-login/register.dart';
import 'package:walk_and_win/screens/splash.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      Color myColor = primarycolor;

    MaterialColor myThemeColor = MaterialColor(
      myColor.value,
      <int, Color>{
        50: myColor.withOpacity(0.1), // Define shades for the color (50 to 900)
        100: myColor.withOpacity(0.2),
        200: myColor.withOpacity(0.3),
        300: myColor.withOpacity(0.4),
        400: myColor.withOpacity(0.5),
        500: myColor.withOpacity(0.6),
        600: myColor.withOpacity(0.7),
        700: myColor.withOpacity(0.8),
        800: myColor.withOpacity(0.9),
        900: myColor.withOpacity(1.0),
      },
    );
       ThemeData myTheme = ThemeData(
      primarySwatch: myThemeColor,
    );
    return MaterialApp(
      title: 'Walk and win',
      theme: myTheme,
      builder: EasyLoading.init(),
      home:  splashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
