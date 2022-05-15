import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 90,
          height: 80,
          child: Image.asset("assets/books.png"),
        ),
      ),
    );
  }
}
