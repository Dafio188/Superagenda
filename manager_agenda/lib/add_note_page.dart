import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_agenda/database_helper.dart';
import 'package:manager_agenda/note.dart';

class AddNotePage extends StatefulWidget {
  final int projectId;

  AddNotePage({required this.projectId});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final dbHelper = DatabaseHelper();
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              _image == null
                  ? Container()
                  : Image.file(File(_image!.path)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                  ),
                  IconButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo_library),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final note = Note(
                      title: _titleController.text,
                      content: _contentController.text,
                      projectId: widget.projectId,
                    );
                    final noteId = await dbHelper.saveNote(note);
                    if (_image != null) {
                      final image = Image(
                        path: _image!.path,
                        noteId: noteId,
                      );
                      await dbHelper.saveImage(image);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
