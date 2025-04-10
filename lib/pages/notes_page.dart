import 'package:flutter/material.dart';
import 'package:notise/components/add_edit_folder_window.dart';
import 'package:notise/components/add_note_window.dart';
import 'package:notise/components/custom_floating_action_button.dart';
import 'package:notise/components/main_app_bar.dart';
import 'package:notise/pages/notes_view_page.dart';
import 'package:notise/data/notes_database.dart';
import 'package:notise/pages/folders_view_page.dart';
import 'package:provider/provider.dart';

import '../components/bottom_nav_bar_painter.dart';
import '../components/bottom_nav_tile.dart';

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

  // For disabling UI parts on bottom sheet opening
  late bool _isBottomSheetOpen;


  @override
  void initState() {
    super.initState();
    
    titleController = TextEditingController();
    textController = TextEditingController();

    folderNameController = TextEditingController();

    _currentIndex = 0;

    _isBottomSheetOpen = false;

    readItems();
  }

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    folderNameController.dispose();

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
            context.read<NotesDatabase>().addNote(titleController.text, textController.text, null);

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
      builder: (BuildContext context) => AddEditFolderWindow(
        actionTitle: "New folder",
        sumbitButtonName: "Create",
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

  void readItems() {
    context.read<NotesDatabase>().fetchNotes();
    context.read<NotesDatabase>().fetchFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const MainAppBar(
        title: "Notes"
      ),
      floatingActionButton: Visibility(
        visible: !_isBottomSheetOpen,
        child: CustomFloatingActionButton(
          onPressed: _currentIndex == 0 ? createNote : createFolder
        ),
      ),
      body: SizedBox.expand(
        child: _currentIndex == 0 ? NotesViewPage(
          onBottomSheetOpened: () {
            setState(() { _isBottomSheetOpen = true; });
          },
          onBottomSheetClosed: () {
            setState(() { _isBottomSheetOpen = false; });
          }
        )
        : FoldersViewPage(
          onBottomSheetOpened: () {
            setState(() { _isBottomSheetOpen = true; });
          },
          onBottomSheetClosed: () {
            setState(() { _isBottomSheetOpen = false; });
          }
        )
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: BottomNavBarPainter(
                  color: Theme.of(context).colorScheme.secondary,
                )
              )
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomNavTile(
                    icon: Icons.home,
                    label: "Home",
                    isSelected: _currentIndex == 0,
                    onTap: () {
                      bottomBarNavigation(0);
                    }
                  ),
              
                  const SizedBox(width: 64),
              
                  BottomNavTile(
                    icon: Icons.folder,
                    label: "Folders",
                    isSelected: _currentIndex == 1,
                    onTap: () {
                      bottomBarNavigation(1);
                    }
                  )
                ]
              ),
            ),

            Positioned(
              bottom: 10,
              child: SizedBox.square(
                dimension: 64,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8
                      )
                    ],
                    shape: BoxShape.circle
                  ),
                  child: IconButton.filled(
                    iconSize: 30,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    onPressed: () {
                      // TODO search
                    },
                    icon: Icon(
                      Icons.search
                    )
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}