import 'dart:io';

import 'package:notes_gallery/models/note.dart';
import 'package:notes_gallery/provider/noteProvider.dart';
import 'package:notes_gallery/screens/NotesScreen/widgets/pdfCard.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future getPdfAndUpload(Note note) async {
    FirebaseStorage instanceFirebase = FirebaseStorage.instanceFor(
        bucket: 'gs://notegallery-f483a.appspot.com');

    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);
    if (file != null) {
      String fileName = file.files.first.name;
      try {
        final firebaseRef = instanceFirebase.ref('uploads').child(fileName);
        File resultFile = File(file.files.single.path!);
        print(resultFile);
        EasyLoading.show(status: 'Uploading...');
        final TaskSnapshot snapshot = await firebaseRef.putFile(
            resultFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'A bad guy',
              'description': 'Some description...'
            }));
        final downloadUrl = await snapshot.ref.getDownloadURL();

        final provider = Provider.of<NotesProvider>(context, listen: false);
        await provider.addPdfNote(
          Note(
            subject: note.subject,
            year: note.year,
            creatorId: note.creatorId,
            noteId: note.noteId,
            name: note.name,
            url: downloadUrl,
            likes: note.likes,
          ),
        );
        Navigator.pop(context);
        EasyLoading.dismiss();
      } on FirebaseException catch (e) {
        print(e);
        return null;
      }
    }
  }

  Future<void> _loadPDfs(BuildContext context) async {
    await Provider.of<NotesProvider>(context, listen: false).fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    String subject = "";
    String year = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        backgroundColor: Color.fromRGBO(28, 101, 133, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _loadPDfs(context),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    )
                  : RefreshIndicator(
                      color: Colors.grey,
                      onRefresh: () => _loadPDfs(context),
                      child: Consumer<NotesProvider>(
                        builder: (context, note, _) {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 180,
                                    childAspectRatio: 6 / 7,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: note.notesList.length,
                            itemBuilder: (context, i) => PdfCard(
                              note: note.notesList[i],
                              userId: note.userId ?? "",
                            ),
                          );
                        },
                      ),
                    );
            }),
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
              child: StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  title: Text("Lets Add Something :)"),
                  content: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                          hint: Text(year.isEmpty ? "select a year" : year),
                          items: <String>['I', 'II', 'III', 'IV']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              year = value ?? "";
                            });
                          },
                        ),
                        DropdownButton<String>(
                          hint: Text(
                              subject.isEmpty ? "select subject" : subject),
                          items:
                              <String>['A', 'B', 'C', 'D'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              subject = value ?? "";
                            });
                          },
                        ),
                        Text("Select a pdf from your device:"),
                        Consumer<NotesProvider>(
                          builder: (context, note, child) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 30,
                            width: 80,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  getPdfAndUpload(Note(
                                    subject: subject,
                                    year: year,
                                    creatorId: note.userId ?? "",
                                    noteId: "",
                                    name: "name",
                                    url: "",
                                    likes: [],
                                  ));
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
                          ),
                        )
                      ],
                    ),
                  ),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
