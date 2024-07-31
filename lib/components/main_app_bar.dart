import 'package:flutter/material.dart';
import 'package:notise/pages/folder_page.dart';
import 'package:notise/pages/note_details_page.dart';
import 'package:notise/pages/settings_page.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool isInEditState;
  final VoidCallback? onEditStateFinished;
  final Map<String, VoidCallback>? popupMenuOptionsCallbacks;

  const MainAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.isInEditState = false,
    this.onEditStateFinished,
    this.popupMenuOptionsCallbacks
  });

  // PreferredSizeWidget interface implementation
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {


  void openSettings() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const SettingsPage()
      ) 
    );    
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.showBackButton
        ? BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        )
        : null,
      title: Text(
          widget.title ?? "" 
        ),
      centerTitle: true,
      backgroundColor: Colors.blue.shade900,
      foregroundColor: Colors.white,
      elevation: 4.0,
      actions: [

        // Different buttons based on different pages
        (context.findAncestorWidgetOfExactType<NoteDetailsPage>() == null && context.findAncestorWidgetOfExactType<FolderPage>() == null)
        ? IconButton(
          onPressed: () => openSettings(),
          icon: const Icon(
            Icons.settings,
            color: Colors.white
          )
        )

        : widget.isInEditState
        ? IconButton(
          onPressed: () {
            widget.onEditStateFinished!();
          },
          icon: const Icon(
            Icons.check,
            color: Colors.white
          )
        )
        : PopupMenuButton(
          onSelected: (String value) {
            if (value == "Delete") {
              widget.popupMenuOptionsCallbacks![value]!.call();
              Navigator.pop(context);
            }
          },
          color: Colors.black,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: "Delete",
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white
                )
              )
            )
          ]
        )
      ]
    );
  }
}
