import 'package:flutter/material.dart';
import 'package:notes_gallery/utils/constants/semester_name.dart';

class SemesterScreen extends StatelessWidget {
  const SemesterScreen({Key? key}) : super(key: key);
  static const routName = '/semester';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(28, 101, 133, 1),
        title: Text("Semester's"),
      ),
      body: ListView(
        children: semList
            .map((e) => Column(
                  children: [
                    ListTile(
                      title: Text(
                        e,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
