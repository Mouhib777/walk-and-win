import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:walk_and_win/constant/constant.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () async {
      final locationData =

      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  welcomeScreen()));
        } else {
          if (locationData.permissionAllowed == true) {
            Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    navBar()));
          }
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TAK TAK",
              style: GoogleFonts.montserrat(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Ready to serve you",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}