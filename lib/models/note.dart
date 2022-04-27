class Note {
  final String year;
  final String subject;
  final String creatorId;
  final String name;
  final String noteId;
  final String url;
  List<dynamic> likes;
  Note({
    required this.subject,
    required this.year,
    required this.creatorId,
    required this.noteId,
    required this.name,
    required this.url,
    required this.likes,
  });
}
