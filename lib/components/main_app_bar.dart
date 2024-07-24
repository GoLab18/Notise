import 'package:flutter/material.dart';
import 'package:notes_app/pages/note_details_page.dart';
import 'package:notes_app/pages/settings_page.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  bool isInEditState;
  final VoidCallback? onEditStateFinished;

  MainAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.isInEditState = false,
    this.onEditStateFinished
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

    void editStateFinished() {
      setState(() {
        widget.isInEditState = false;
      });

      // Function editStateFinished() is only called when the app bar is reactive
      widget.onEditStateFinished!();
    }

    return AppBar(
      leading: widget.showBackButton
        ? BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        )
        : null,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
            widget.title ?? "" 
          ),
      ),
      backgroundColor: Colors.blue.shade900,
      foregroundColor: Colors.white,
      elevation: 4.0,
      actions: [

        // Different buttons based on different pages
        (context.findAncestorWidgetOfExactType<NoteDetailsPage>() == null)
        ? IconButton(
          onPressed: () {
            widget.isInEditState
              ? editStateFinished()
              : openSettings();
          },
          icon: Icon(
            widget.isInEditState
              ? Icons.check
              : Icons.settings,
            color: Colors.white
          )
        )

        // NoteDetailsPage
        : widget.isInEditState
        ? IconButton(
          onPressed: () {
            editStateFinished();
          },
          icon: const Icon(
            Icons.check,
            color: Colors.white
          )
        )
        : PopupMenuButton(
          onSelected: (String value) {
            // TODO custom normalized dialog window
            if (value == "Delete") null;
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
