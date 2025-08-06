class Project {
  int? id;
  String name;
  String description;
  int userId;

  Project({this.id, required this.name, required this.description, required this.userId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'description': description,
      'userId': userId,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Project.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        userId = map['userId'];
}
