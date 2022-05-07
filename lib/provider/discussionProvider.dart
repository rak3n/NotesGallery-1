import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes_gallery/models/commentModel.dart';
import 'package:notes_gallery/models/feedModel.dart';
import 'package:notes_gallery/models/userModel.dart';

class DiscussionProvider with ChangeNotifier {
  List<Feed> feedList = [];

  Future<void> fetchFeeds() async {
    final url =
        Uri.parse("http://protected-waters-32301.herokuapp.com/getFeeds");

    final response = await http.get(url);

    print("RESPonsE OF GET FEED  --->${response.body}");

    final responseData = json.decode(response.body) as List;

    final List<Feed> tempFeedList = [];

    responseData.forEach((feed) {
      final List<dynamic> feedItemCommmentList = feed['comments'];
      final List<Comment> comments = [];

      feedItemCommmentList.forEach((comment) {
        comments.add(Comment.fromJson(json: comment));
      });
      final Feed feedItem = Feed(
        feedId: feed['feedId'],
        feedText: feed['feedText'],
        date: feed["date"],
        commentList: comments,
        postedBy: UserModel.fromJson(
          json: feed["postedBy"],
        ),
      );

      tempFeedList.add(feedItem);
    });

    feedList = tempFeedList;
    print("YE BOI THIS IS REAL FCK --> ${feedList.length}");
    notifyListeners();
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
