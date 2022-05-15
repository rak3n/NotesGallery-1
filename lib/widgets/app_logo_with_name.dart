import 'package:flutter/material.dart';

class AppLogoWithName extends StatelessWidget {
  const AppLogoWithName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon(
        //   Icons.ac_unit_outlined,
        //   size: 70,
        //   color: Color.fromRGBO(28, 101, 133, 1),
        // ),
        Container(
          width: 90,
          height: 80,
          child: Image.asset("assets/books.png"),
        ),

        SizedBox(
          height: 10,
        ),
        Text(
          "NOTESGALLERY",
          style: TextStyle(
            color: Color.fromRGBO(28, 101, 133, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
