class Note {
  int? id;
  String title;
  String content;
  int projectId;

  Note({this.id, required this.title, required this.content, required this.projectId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'content': content,
      'projectId': projectId,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Note.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        content = map['content'],
        projectId = map['projectId'];
}
