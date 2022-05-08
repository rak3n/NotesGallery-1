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

  Future<void> postFeed(
      {required UserModel currentUser, required String feedText}) async {
    final url =
        Uri.parse("http://protected-waters-32301.herokuapp.com/postFeed");

    final resposne = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'feedText': feedText,
          'userInfo': {
            'uid': currentUser.uid,
            'displayName': currentUser.displayName,
            'isStudent': currentUser.isStudent,
          }
        },
      ),
    );
    final responseData = json.decode(resposne.body);

    feedList.add(
      Feed(
        feedId: responseData['result']['feedId'],
        feedText: feedText,
        date: DateTime.now().toIso8601String(),
        commentList: [],
        postedBy: currentUser,
      ),
    );
    notifyListeners();
    print("RESPONSE OF POST FEED  --->${resposne.body}");
  }

  Future<void> postComment({
    required String feedId,
    required String commentText,
    required UserModel currentUser,
  }) async {
    final url =
        Uri.parse("http://protected-waters-32301.herokuapp.com/postComment");
    print("post comment me jaake user details  ${currentUser.displayName} ");
    final resposne = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'feedId': feedId,
          'commentText': commentText,
          'userInfo': {
            'uid': currentUser.uid,
            'displayName': currentUser.displayName,
            'isStudent': currentUser.isStudent,
          }
        },
      ),
    );
    print("RESPONSE OF Commments addition FEED  --->${resposne.body}");

    final responseData = json.decode(resposne.body);

    final feed = feedList.firstWhere((element) => element.feedId == feedId);
    feed.commentList.add(
      Comment(
        commentId: responseData['result']['commentId'],
        feedId: feedId,
        commentText: commentText,
        date: DateTime.now().toIso8601String(),
        userInfo: currentUser,
      ),
    );
    notifyListeners();
  }
}
