import 'package:flutter/material.dart';
import 'package:notes_gallery/provider/authProvider.dart';
import 'package:notes_gallery/screens/HomePageScreen/widgets/drawer_side.dart';
import 'package:notes_gallery/widgets/box_gridView.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        // toolbarOpacity: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notes Gallery",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(28, 101, 133, 1)),
            ),
            Text(
              "A smart way for sharing notes",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(169, 170, 183, 1),
              ),
            ),
          ],
        ),
      ),
      drawer: SideDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.transparent,
              child: Text(
                "Welcome User",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(28, 101, 133, 1)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: BoxGridView(),
            ),
          ],
        ),
      ),
    );
  }
}
