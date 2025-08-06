import 'package:flutter/material.dart';
import 'package:manager_agenda/add_project_page.dart';
import 'package:manager_agenda/database_helper.dart';
import 'package:manager_agenda/project.dart';

class ProjectsPage extends StatefulWidget {
  final int userId;

  ProjectsPage({required this.userId});

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final dbHelper = DatabaseHelper();
  late Future<List<Project>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = dbHelper.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: FutureBuilder<List<Project>>(
        future: _projects,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TasksPage(projectId: snapshot.data![index].id!),
                      ),
                    );
                  },
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
              builder: (context) => AddProjectPage(userId: widget.userId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
