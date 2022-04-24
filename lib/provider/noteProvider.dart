import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/models/note.dart';

class NotesProvider with ChangeNotifier {
  Future<void> addPdfNote(Note note) async {
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/note.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': note.name,
            'id': note.id,
            'likes': note.likes,
            'url': note.url,
          }));
      print("RESPONSE BODY->${response.body}");
    } catch (e) {
      print(e);
    }
  }
}
