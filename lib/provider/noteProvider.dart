import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notesList = [];

  Future<void> addPdfNote(Note note) async {
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/note.json');
    try {
      final response = await http.post(url,
          body: json.encode({
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

    final List<Note> noteTempList = [];
    responseData.forEach((id, noteData) {
      noteTempList.add(
        Note(
          creatorId: 'creatorId',
          noteId: id,
          name: noteData['name'],
          url: noteData['url'],
          likes: noteData['likes'],
        ),
      );
    });
    notesList = noteTempList;

    print(" fetchNotes response->     ${json.decode(response.body)}");
    print(notesList.length);
    notifyListeners();
  }
}
