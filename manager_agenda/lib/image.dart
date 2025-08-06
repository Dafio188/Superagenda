class Image {
  int? id;
  String path;
  int noteId;

  Image({this.id, required this.path, required this.noteId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'path': path,
      'noteId': noteId,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Image.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        path = map['path'],
        noteId = map['noteId'];
}
