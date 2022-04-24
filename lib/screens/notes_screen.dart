import 'dart:io';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);
  static const routName = '/notes';

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map> tempData = <Map>[];
  FirebaseStorage instanceFirebase = FirebaseStorage.instanceFor(
      bucket: 'gs://notesgallery-8b124.appspot.com');
  bool isPDFRequested = false;
  bool isPDFLoading = false;
  Uint8List? _documentBytes;

  Future<void> getFirebaseData() async {
    EasyLoading.show(status: 'Fetching...');
    final result = await instanceFirebase.ref('uploads').listAll();
    List<Map> results = await Future.wait(result.items.map((final ref) async {
      final down = await ref.getDownloadURL();
      final downloadURL = down.toString();
      return {
        "downloadURL": downloadURL,
        "name": getFileName(downloadURL),
      };
    }));
    EasyLoading.dismiss();
    setState(() {
      tempData = results;
    });
  }

  String getFileName(String url) {
    RegExp regExp = new RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(url);

    var match = matches.elementAt(0);
    print("${Uri.decodeFull(match.group(2)!)}");
    return Uri.decodeFull(match.group(2)!);
  }

  @override
  void initState() {
    super.initState();
    getFirebaseData();
  }

  void _loadFile(path) async {
    setState(() {
      isPDFRequested = true;
      isPDFLoading = true;
    });
    HttpClient client = HttpClient();
    final Uri url = Uri.base.resolve(path);
    final HttpClientRequest request = await client.getUrl(url);
    final HttpClientResponse response = await request.close();
    _documentBytes = await consolidateHttpClientResponseBytes(response);

    setState(() {
      isPDFLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future getPdfAndUpload() async {
      // String randomName = "someName";
      final file = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false);
      // String fileName = '${randomName}.pdf';
      if (file != null) {
        print('In here');
        String fileName = file.files.first.name;
        try {
          final firebaseRef = instanceFirebase.ref('uploads').child(fileName);
          File resultFile = File(file.files.single.path!);
          print(resultFile);
          // Upload file
          EasyLoading.show(status: 'Uploading...');
          final TaskSnapshot snapshot = await firebaseRef.putFile(
              resultFile,
              SettableMetadata(customMetadata: {
                'uploaded_by': 'A bad guy',
                'description': 'Some description...'
              }));
          final downloadUrl = await snapshot.ref.getDownloadURL();
          print(downloadUrl);
          Navigator.pop(context);
          EasyLoading.dismiss();
          getFirebaseData();
        } on FirebaseException catch (e) {
          print(e);
          return null;
        }
      }
    }

    if (isPDFRequested) {
      Widget child = const Center(child: CircularProgressIndicator());
      if (_documentBytes != null) {
        child = SfPdfViewer.memory(
          _documentBytes!,
        );
      }
      return Scaffold(
          appBar: AppBar(
            title: Text("Your Notes"),
            backgroundColor: Color.fromRGBO(28, 101, 133, 1),
          ),
          body: child);
    }

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
          children: tempData
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    print('LOAD PDF\n\n\n');
                    _loadFile(e['downloadURL']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(e['name']),
                        Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Colors.red,
                        )
                      ],
                    ),
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
                          child: GestureDetector(
                            onTap: () {
                              getPdfAndUpload();
                            },
                            child: Text(
                              "Select a file",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
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
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text(
                  //     "Save",
                  //     style: TextStyle(
                  //       color: Color.fromRGBO(28, 101, 133, 1),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
