import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/models/userModel.dart';

class DiscussionProvider with ChangeNotifier {
  Future<void> fetchFeeds() async {
    final url =
        Uri.parse("http://protected-waters-32301.herokuapp.com/getFeeds");

    final resposne = await http.get(url);

    print("RESPonsE OF GET FEED  --->${resposne.body}");
  }

  Future<void> postFeed(userInfo, feedText) async {
    final url =
        Uri.parse("http://protected-waters-32301.herokuapp.com/postFeed");

    final resposne = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'feedText': "hello kumar fck me harder bae",
          'userInfo': {
            'uid': "iuiuu",
            'displayName': "Kumis is sexy boii",
            'isStudent': true,
          }
        },
      ),
    );

    print("RESPONSE OF POST FEED  --->${resposne.body}");
  }

  Future<void> postComment(userInfo, feedText) async {
    final url =
        Uri.parse("http://protected-waters-32301.herokuapp.com/postComment");

    final resposne = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'feedId': "3b98bffc-08c9-4f25-ac37-7a49480d0434",
          'commentText': "hello kumar ",
          'userInfo': {
            'uid': "iuiuu",
            'displayName': "Kumar",
            'isStudent': true,
          }
        },
      ),
    );

    print("RESPONSE OF POST FEED  --->${resposne.body}");
  }
}
