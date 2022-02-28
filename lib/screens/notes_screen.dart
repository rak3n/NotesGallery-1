import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);
  static const routName = '/notes';

  @override
  Widget build(BuildContext context) {
    List tempdata = [
      "Maths",
      "Science",
      "English",
      "Chemistry",
      "Maths",
      "Science",
      "English",
      "Chemistry"
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        backgroundColor: Color.fromRGBO(28, 101, 133, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 5 / 6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: tempdata
              .map(
                (e) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(e),
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 25,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: AlertDialog(
                title: Text("Lets Add Something :)"),

                content: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                          "Select a pdf from your device to add to the notes:"),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 30,
                        width: 80,
                        child: Center(
                          child: Text(
                            "Select a file",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //   backgroundColor: Colors.blueGrey,

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color.fromRGBO(28, 101, 133, 1),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Color.fromRGBO(28, 101, 133, 1),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
