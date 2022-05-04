import 'package:flutter/material.dart';
import 'package:notes_gallery/provider/authProvider.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: Center(
                child: Text(
                  "WELCOME USER",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(169, 170, 183, 1),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: 25,
                color: Colors.blueGrey,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 131, 132, 145),
                ),
              ),
              onTap: () {
                Provider.of<Authentication>(context, listen: false).logout();
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
