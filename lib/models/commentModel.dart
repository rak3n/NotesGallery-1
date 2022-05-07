import 'package:notes_gallery/models/userModel.dart';

class Comment {
  final String commentId;
  final String feedId;
  final UserModel userInfo;
  final String commentText;
  final String date;
  Comment({
    required this.commentId,
    required this.feedId,
    required this.commentText,
    required this.date,
    required this.userInfo,
  });

  factory Comment.fromJson({
    required Map<String, dynamic> json,
  }) {
    return Comment(
      commentId: json['commentId'],
      feedId: json['feedId'],
      commentText: json['commentText'],
      date: json['date'],
      userInfo: UserModel.fromJson(json: json['userInfo']),
    );
  }
}
