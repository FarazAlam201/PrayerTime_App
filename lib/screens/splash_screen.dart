import 'dart:async';
import 'package:flutter/material.dart';
import 'prayer_time_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PrayerTimeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Spacer(),
                Image.asset("assets/logo.png"),
                Text(
                  "Prayer Time",
                  style: GoogleFonts.kaushanScript(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                Spacer(),
              ],
            )),
      ),
    );
  }
}
