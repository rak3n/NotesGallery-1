class Comment {
  final String commentId;
  final String feedId;
  final Object userInfo;
  final String commentText;
  final String date;
  Comment({
    required this.commentId,
    required this.feedId,
    required this.commentText,
    required this.date,
    required this.userInfo,
  });
}
