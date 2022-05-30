import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notesList = [];
  final String? userId;
  final String? token;

  NotesProvider({
    required this.userId,
    required this.token,
    required this.notesList,
  });
  List<String> subjects = [];
  bool useLikeOrDislike(String userId, Note note) {
    if (userId.isEmpty) {
      return false;
    }
    if (note.likes.contains(userId)) {
      dislikeHit(userId, note);
      return false;
    } else {
      likeHit(userId, note);
      return true;
    }
  }

  Future<void> likeHit(String userId, Note note) async {
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/note/${note.noteId}.json');

    final index =
        notesList.indexWhere((element) => element.noteId == note.noteId);

    if (notesList[index].likes.contains(userId)) {
      return;
    }
    note.likes.add(userId);
    final response = await http.patch(url,
        body: json.encode({
          'likes': note.likes,
        }));
    print(" UPLOAD RESPONSE->.>>>>  ${response.body}");
    notesList[index].likes = note.likes;
    notifyListeners();
  }

  Future<void> dislikeHit(String userId, Note note) async {
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/note/${note.noteId}.json');

    final index =
        notesList.indexWhere((element) => element.noteId == note.noteId);

    if (notesList[index].likes.contains(userId) == false) {
      return;
    }
    note.likes.remove(userId);
    final response = await http.patch(url,
        body: json.encode({
          'likes': note.likes,
        }));

    notesList[index].likes = note.likes;
    notifyListeners();
  }

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
            'likes': [],
            'url': note.url,
            'branch': note.branch,
          }));
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchSubjectsLists() async {
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/subject.json');

    final response = await http.get(url);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    print("my subjects lists ka response data---->   $responseData");

    List<String> subjectsList = [];

    responseData.forEach((key, value) {
      final listSub = value['subjects'] as List;
      listSub.forEach((element) {
        subjectsList.add(element);
      });
    });

    subjects = subjectsList;
    print(subjects);
    notifyListeners();
  }

  Future<void> addSubjectsList() async {
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/subject.json');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'subjects': [
            "Maths",
            "Physics",
            "TOC",
            "OOPs",
            "DSA",
            "Communication Skills",
            "OS",
            "CG",
            "CD",
          ],
        },
      ),
    );
  }

  Future<void> fetchNotes(
      {bool filterByCreatorId = false,
      String? branch,
      String? year,
      required bool filterByBranchAndYear}) async {
    String filterString =
        filterByCreatorId ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    final url = Uri.parse(
        'https://notegallery-f483a-default-rtdb.europe-west1.firebasedatabase.app/note.json?$filterString');
    try {
      final response = await http.get(url);

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData == null) return;
      print('Response  data for fetch Pdf--->$responseData');
      final List<Note> noteTempList = [];
      responseData.forEach(
        (id, noteData) {
          noteTempList.add(
            Note(
              year: noteData['year'],
              subject: noteData['subject'],
              creatorId: 'creatorId',
              noteId: id,
              name: noteData['name'],
              branch: noteData['branch'],
              url: noteData['url'],
              likes: noteData['likes'] == null
                  ? []
                  : noteData['likes'] as List, //TODO: change here:
            ),
          );
        },
      );

      if (filterByBranchAndYear) {
        notesList = noteTempList
            .where(
                (element) => element.branch == branch && element.year == year)
            .toList();
      } else {
        notesList = noteTempList;
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

// void filterByBranchAndYear({ required String branch,required String year}){
//  notesList
//           .where((element) => element.branch == branch && element.year == year)
//           .toList();
// }

}
