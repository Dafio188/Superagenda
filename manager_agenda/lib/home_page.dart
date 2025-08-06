import 'package:flutter/material.dart';
import 'package:manager_agenda/notes_page.dart';
import 'package:manager_agenda/projects_page.dart';
import 'package:manager_agenda/user.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      ProjectsPage(userId: widget.user.id!),
      NotesPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.folder),
            title: new Text('Projects'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.note),
            title: new Text('Notes'),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
