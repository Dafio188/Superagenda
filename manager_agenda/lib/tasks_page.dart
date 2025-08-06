import 'package:flutter/material.dart';
import 'package:manager_agenda/database_helper.dart';
import 'package:manager_agenda/note.dart';

class TasksPage extends StatefulWidget {
  final int projectId;

  TasksPage({required this.projectId});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final dbHelper = DatabaseHelper();
  late Future<List<Note>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = dbHelper.getNotes(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: FutureBuilder<List<Note>>(
        future: _tasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].content),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(projectId: widget.projectId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
