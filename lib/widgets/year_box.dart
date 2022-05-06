import 'package:flutter/material.dart';

// ignore: must_be_immutable
class YearBox extends StatelessWidget {
  late String yearName;
  late Color color;
  late String assetImage;
  YearBox({
    required this.yearName,
    required this.color,
    required this.assetImage,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 182,
      width: 148,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("$assetImage"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(9),
        color: color,
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Container(
              height: null,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: LinearGradient(
                    colors: [Colors.blueGrey, Colors.blue],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.5, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          Center(
            child: Text(
              yearName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
