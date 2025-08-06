import 'dart:async';
import 'dart:io';

import 'package:manager_agenda/image.dart';
import 'package:manager_agenda/note.dart';
import 'package:manager_agenda/project.dart';
import 'package:manager_agenda/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // Create tables
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
    await db.execute(
        "CREATE TABLE Project(id INTEGER PRIMARY KEY, name TEXT, description TEXT, userId INTEGER, FOREIGN KEY(userId) REFERENCES User(id))");
    await db.execute(
        "CREATE TABLE Note(id INTEGER PRIMARY KEY, title TEXT, content TEXT, projectId INTEGER, FOREIGN KEY(projectId) REFERENCES Project(id))");
    await db.execute(
        "CREATE TABLE Image(id INTEGER PRIMARY KEY, path TEXT, noteId INTEGER, FOREIGN KEY(noteId) REFERENCES Note(id))");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient!.insert("User", user.toMap());
    return res;
  }

  Future<User?> getUser(String username, String password) async {
    var dbClient = await db;
    var res = await dbClient!.query("User",
        where: "username = ? and password = ?", whereArgs: [username, password]);
    if (res.length > 0) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<int> saveProject(Project project) async {
    var dbClient = await db;
    int res = await dbClient!.insert("Project", project.toMap());
    return res;
  }

  Future<List<Project>> getProjects() async {
    var dbClient = await db;
    var res = await dbClient!.query("Project");
    return res.isNotEmpty ? res.map((c) => Project.fromMap(c)).toList() : [];
  }

  Future<int> saveNote(Note note) async {
    var dbClient = await db;
    int res = await dbClient!.insert("Note", note.toMap());
    return res;
  }

  Future<List<Note>> getNotes(int projectId) async {
    var dbClient = await db;
    var res = await dbClient!.query("Note", where: "projectId = ?", whereArgs: [projectId]);
    return res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
  }

  Future<int> saveImage(Image image) async {
    var dbClient = await db;
    int res = await dbClient!.insert("Image", image.toMap());
    return res;
  }

  Future<List<Image>> getImages(int noteId) async {
    var dbClient = await db;
    var res = await dbClient!.query("Image", where: "noteId = ?", whereArgs: [noteId]);
    return res.isNotEmpty ? res.map((c) => Image.fromMap(c)).toList() : [];
  }
}
