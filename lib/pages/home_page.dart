import 'package:flutter/material.dart';
import 'package:notise/components/add_edit_folder_window.dart';
import 'package:notise/components/add_note_window.dart';
import 'package:notise/components/custom_floating_action_button.dart';
import 'package:notise/components/main_app_bar.dart';
import 'package:notise/pages/notes_view_page.dart';
import 'package:notise/data/notes_database.dart';
import 'package:notise/pages/folders_view_page.dart';
import 'package:provider/provider.dart';

import '../components/bottom_nav_bar.dart';
import '../components/bottom_nav_tile.dart';
import '../components/search_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _NotesPageState();
}

class _NotesPageState extends State<HomePage> with TickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController textController;

  late TextEditingController folderNameController;

  late AnimationController searchAnimController;
  late CurvedAnimation searchAnim;

  // For bottom nav bar
  late int currIndex;

  // For disabling UI parts on bottom sheet opening
  late bool isBottomSheetOpen;
  
  bool isSearchOpen = false, isAnimatingSearch = false;

  @override
  void initState() {
    super.initState();
    
    titleController = TextEditingController();
    textController = TextEditingController();

    folderNameController = TextEditingController();

    searchAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    searchAnim = CurvedAnimation(parent: searchAnimController, curve: Curves.fastEaseInToSlowEaseOut);

    searchAnim.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() { isAnimatingSearch = true; });
      } else if (status == AnimationStatus.reverse) {
        setState(() { isSearchOpen = false; });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          isAnimatingSearch = false;
          isSearchOpen = false;
        });
      } else if (status == AnimationStatus.completed) {
        if (!isSearchOpen) {
          setState(() {
            isSearchOpen = true;
          });
        }
      }
    });

    currIndex = 0;

    isBottomSheetOpen = false;

    readItems();
  }

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    folderNameController.dispose();
    searchAnim.dispose();

    super.dispose();
  }
  
  void bottomBarNavigation(int index) {
    setState(() {
      currIndex = index;
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
        submitButtonName: "Create",
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

  Scaffold buildMainScaffold() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBody: true,
      appBar: const MainAppBar(
        title: "Notise"
      ),
      floatingActionButton: Visibility(
        visible: !isBottomSheetOpen && !isSearchOpen,
        child: CustomFloatingActionButton(
          onPressed: currIndex == 0 ? createNote : createFolder
        ),
      ),
      body: SizedBox.expand(
        child: currIndex == 0 ? NotesViewPage(
          onBottomSheetOpened: () {
            setState(() { isBottomSheetOpen = true; });
          },
          onBottomSheetClosed: () {
            setState(() { isBottomSheetOpen = false; });
          }
        )
        : FoldersViewPage(
          onBottomSheetOpened: () {
            setState(() { isBottomSheetOpen = true; });
          },
          onBottomSheetClosed: () {
            setState(() { isBottomSheetOpen = false; });
          }
        )
      ),
      bottomNavigationBar: BottomNavBar(
        onSearch: () {
          searchAnimController.forward(from: 0.0);
        },
        children: [
          BottomNavTile(
            icon: Icons.home,
            label: "Home",
            isSelected: currIndex == 0,
            onTap: () {
              bottomBarNavigation(0);
            }
          ),
      
          const SizedBox(width: 64),
      
          BottomNavTile(
            icon: Icons.folder,
            label: "Folders",
            isSelected: currIndex == 1,
            onTap: () {
              bottomBarNavigation(1);
            }
          )
        ]
      )
    );
  }

  Widget buildExpandingSearch() {
    final screenSize = MediaQuery.of(context).size;
    final Offset center = Offset(screenSize.width / 2, screenSize.height - 42);

    return Positioned.fill(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: searchAnim,
            builder: (context, child) {
              double radius = searchAnim.value * screenSize.height * 1.5;

              return Positioned(
                left: center.dx - radius,
                top: center.dy - radius,
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary
                  )
                )
              );
            }
          ),

          if (isSearchOpen) SearchOverlay(
            currIndex: currIndex,
            onClose: () {
              searchAnimController.reverse();
            }
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildMainScaffold(),
        if (isAnimatingSearch || isSearchOpen) buildExpandingSearch()
      ]
    );
  }
}