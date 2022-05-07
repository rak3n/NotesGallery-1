class Feed {
  final String feedId;
  final String feedText;
  final String date;
  final Object postedBy;
  final List<dynamic> commentList;
  Feed({
    required this.feedId,
    required this.feedText,
    required this.date,
    required this.commentList,
    required this.postedBy,
  });
}
