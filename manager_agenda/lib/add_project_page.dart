import 'package:flutter/material.dart';
import 'package:manager_agenda/database_helper.dart';
import 'package:manager_agenda/project.dart';

class AddProjectPage extends StatefulWidget {
  final int userId;

  AddProjectPage({required this.userId});

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Project Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a project description';
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final project = Project(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      userId: widget.userId,
                    );
                    await dbHelper.saveProject(project);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
