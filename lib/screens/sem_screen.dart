import 'package:flutter/material.dart';
import 'package:notes_gallery/utils/constants/semester_name.dart';

class SemesterScreen extends StatelessWidget {
  const SemesterScreen({Key? key}) : super(key: key);
  static const routName = '/semester';
  @override
  Widget build(BuildContext context) {
    final branch = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(28, 101, 133, 1),
        title: Text("Choose Your Year"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: yearList
              .map((e) => Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(28, 101, 133, 1),
                              Colors.blueGrey
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.9, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/notes',
                              arguments: {
                                'branch': branch,
                                'year': e,
                              },
                            );
                          },
                          title: Center(
                            child: Text(
                              e,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
