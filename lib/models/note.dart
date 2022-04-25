class Note {
  final String creatorId;
  final String name;
  final String noteId;
  final String url;
  List<dynamic> likes;
  Note({
    required this.creatorId,
    required this.noteId,
    required this.name,
    required this.url,
    required this.likes,
  });
}
