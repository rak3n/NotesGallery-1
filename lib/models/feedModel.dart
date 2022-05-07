import 'package:notes_gallery/models/commentModel.dart';
import 'package:notes_gallery/models/userModel.dart';

class Feed {
  final String feedId;
  final String feedText;
  final String date;
  final UserModel postedBy;
  final List<Comment> commentList;
  Feed({
    required this.feedId,
    required this.feedText,
    required this.date,
    required this.commentList,
    required this.postedBy,
  });
}
