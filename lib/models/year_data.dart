import 'dart:ui';

import 'package:notes_gallery/models/branch_model.dart';

List<Branch> data = [
  Branch(
    branch: "Computer Science",
    color: Color.fromRGBO(60, 95, 148, 1),
    assetsString: "assets/cse.jpeg",
  ),
  Branch(
    branch: "Electronics & Communication",
    color: Color.fromRGBO(85, 152, 161, 1),
    assetsString: "assets/ece.jpg",
  ),
  Branch(
    branch: "Electrical",
    color: Color.fromRGBO(67, 28, 117, 1),
    assetsString: "assets/ee.jpg",
  ),
  Branch(
    branch: "Civil",
    color: Color.fromRGBO(28, 101, 133, 1),
    assetsString: "assets/cv.jpg",
  ),
  Branch(
    branch: "Mechanical",
    color: Color.fromRGBO(28, 101, 133, 1),
    assetsString: "assets/me.jpg",
  ),
];

// ignore: non_constant_identifier_names
final branch_data = [
  "Mechanical",
  "Civil",
  "Electrical",
  "Computer Science",
  "Electronics & Communication",
];
