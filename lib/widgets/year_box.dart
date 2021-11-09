import 'package:flutter/material.dart';

// ignore: must_be_immutable
class YearBox extends StatelessWidget {
  late String yearName;
  late Color color;
  YearBox({required this.yearName, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 182,
      width: 148,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(9), color: color),
      child: Center(
          child: Text(
        yearName,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color.fromRGBO(222, 223, 238, 1)),
      )),
    );
  }
}
