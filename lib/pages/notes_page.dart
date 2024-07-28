import 'package:flutter/material.dart';
import 'package:notes_app/components/add_folder_window.dart';
import 'package:notes_app/components/add_note_window.dart';
import 'package:notes_app/components/custom_floating_action_button.dart';
import 'package:notes_app/components/main_app_bar.dart';
import 'package:notes_app/pages/notes_view_page.dart';
import 'package:notes_app/data/notes_database.dart';
import 'package:notes_app/pages/folders_view_page.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late TextEditingController titleController;
  late TextEditingController textController;

  late TextEditingController folderNameController;

  // For bottom nav bar
  late int _currentIndex;

  late List pages;

  late List<String> noteEdits;
  late String currentEdit;


  @override
  void initState() {
    super.initState();
    
    titleController = TextEditingController();
    textController = TextEditingController();

    folderNameController = TextEditingController();

    _currentIndex = 0;

    pages = const [
      NotesViewPage(),
      FoldersViewPage()
    ];

    noteEdits = [
      "Delete"
    ];

    readItems();
  }

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();

    super.dispose();
  }
  
  void bottomBarNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddNoteWindow(
          titleController: titleController,
          textController: textController,
          onAddPressed:  () {
            context.read<NotesDatabase>().addNote(titleController.text, textController.text);

            titleController.clear();
            textController.clear();

            Navigator.pop(context);
          },
          onCancelPressed: () {
            titleController.clear();
            textController.clear();

            Navigator.pop(context);
          }
        )
    );
  }

  void createFolder() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddFolderWindow(
        folderNameController: folderNameController,
        onAddPressed: () {
            context.read<NotesDatabase>().addFolder(folderNameController.text);

            folderNameController.clear();

            Navigator.pop(context);
        },
        onCancelPressed: () {
          folderNameController.clear();

          Navigator.pop(context);
        }
      )
    );
  }

  void deleteNote(int id) {
    context.read<NotesDatabase>().deleteNote(id);
  }

  void readItems() {
    context.read<NotesDatabase>().fetchNotes();
    context.read<NotesDatabase>().fetchFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 4, 67),
      appBar: const MainAppBar(
        title: "Notes"
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: (_currentIndex == 0) ? createNote : createFolder
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: bottomBarNavigation,
        backgroundColor: Colors.blue.shade900,
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 44, 4, 67),
        items: const [

          //Home
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home
            ),
            label: "Home"
          ),

          // Folders
          BottomNavigationBarItem(
            icon: Icon(
              Icons.folder
            ),
            label: "Folders"
          )
        ]
        )
    );
  }
}