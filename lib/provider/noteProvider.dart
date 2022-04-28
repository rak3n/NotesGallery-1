import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notesList = [];

  Future<String> getUploadPdfFileUrl(FilePickerResult file) async {
    FirebaseStorage instanceFirebase = FirebaseStorage.instanceFor(
      bucket: 'gs://notegallery-f483a.appspot.com',
    );

    String fileName = file.files.first.name;
    final firebaseRef = instanceFirebase.ref('uploads').child(fileName);

    File resultFile = File(file.files.first.name);

    final TaskSnapshot snapshot = await firebaseRef.putFile(
        resultFile,
        SettableMetadata(customMetadata: {
          'uploaded_by': 'A bad guy',
          'description': 'Some description...'
        }));
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }

  Future<void> addPdfNote(Note note) async {
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/note.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'year': note.year,
            'subject': note.subject,
            'creatorId': note.creatorId,
            'name': note.name,
            'noteId': note.noteId,
            'likes': note.likes,
            'url': note.url,
          }));
      print("RESPONSE BODY->${response.body}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchNotes([bool filterByCreatorId = false]) async {
    var userId = "creatorId";
    String filterString =
        filterByCreatorId ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/note.json?$filterString');

    final response = await http.get(url);

    final responseData = json.decode(response.body) as Map<String, dynamic>;

    if (responseData == null) return;
    print('Resposne  data for fecth Pdf--->${responseData}');
    final List<Note> noteTempList = [];
    responseData.forEach((id, noteData) {
      noteTempList.add(
        Note(
          year: noteData['year'],
          subject: noteData['subject'],
          creatorId: 'creatorId',
          noteId: id,
          name: noteData['name'],
          url: noteData['url'],
          likes: noteData['likes'] == null
              ? []
              : noteData['likes'] as List, //TODO: change here:
        ),
      );
    });
    notesList = noteTempList;

    print(" fetchNotes response->     ${json.decode(response.body)}");
    print(notesList.length);
    notifyListeners();
  }
}
