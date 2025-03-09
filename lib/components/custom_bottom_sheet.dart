import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notise/components/add_edit_folder_window.dart';
import 'package:notise/components/add_to_folder_window.dart';
import 'package:notise/data/folder.dart';
import 'package:notise/data/note.dart';
import 'package:notise/data/notes_database.dart';
import 'package:provider/provider.dart';

class CustomBottomSheet extends StatefulWidget {
  final Note? note;
  final Folder? folder;
  final VoidCallback onBottomSheetClosed;
  final bool allowNoteFromFolderDeletion;

  const CustomBottomSheet({
    super.key,
    this.note,
    this.folder,
    required this.onBottomSheetClosed,
    this.allowNoteFromFolderDeletion = false
  }) : assert(note != null || folder != null, 'Specifically one item must be provided');

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  late TextEditingController folderNameController;


  @override
  void initState() {
    super.initState();

    folderNameController = TextEditingController();
  }
  
  @override
  void dispose() {
    folderNameController.dispose();

    super.dispose();
  }

  double initPinAngle() {
    if (widget.note != null) {
      return (widget.note!.isPinned) ?  0 : pi / 4;
    }
    return (widget.folder!.isPinned) ?  0 : pi / 4;
  }

  late double pinAngle = initPinAngle();
  

  void pinAction(int id) {
    setState(() {
      pinAngle = (pinAngle == pi / 4) ? 0 : pi / 4;
    });

    if (widget.note != null) context.read<NotesDatabase>().changeNotePinStatus(id);
    if (widget.folder != null) context.read<NotesDatabase>().changeFolderPinStatus(id);

    widget.onBottomSheetClosed();
    Navigator.pop(context);
  }

  void deleteItem() {
    if (widget.note != null) context.read<NotesDatabase>().deleteNote(widget.note!);
    if (widget.folder != null) context.read<NotesDatabase>().deleteFolder(widget.folder!.id);

    widget.onBottomSheetClosed();
    Navigator.pop(context);
  }

  void addToFolder(List<Folder> currentFolders) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => currentFolders.isNotEmpty
        ? AddToFolderWindow(
          note: widget.note!,
          currentFolders: currentFolders,
          popPreviusWindow: () {
            widget.onBottomSheetClosed();
            Navigator.pop(context);
          }
        )
        : AddEditFolderWindow(
          actionTitle: "New folder",
          sumbitButtonName: "Create",
          folderNameController: folderNameController,
          onAddPressed: () {
            dialogContext.read<NotesDatabase>().addNoteToFolder(
              widget.note!.id,
              null,
              folderNameController.text
            );

            folderNameController.clear();

            widget.onBottomSheetClosed();
            Navigator.pop(dialogContext);
            Navigator.pop(context);
          },
          onCancelPressed: () {
            folderNameController.clear();


            widget.onBottomSheetClosed();
            Navigator.pop(dialogContext);
            Navigator.pop(context);
          }
        )
    );
  }

  void editFolder() {
    folderNameController.text = widget.folder!.name;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AddEditFolderWindow(
        actionTitle: "Edit folder",
        sumbitButtonName: "Ok",
        folderNameController: folderNameController,
        onAddPressed: () {
          dialogContext.read<NotesDatabase>().updateFolder(
            widget.folder!.id,
            folderNameController.text
          );

          folderNameController.clear();

          widget.onBottomSheetClosed();
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        },
        onCancelPressed: () {
          folderNameController.clear();


          widget.onBottomSheetClosed();
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final NotesDatabase db = context.watch<NotesDatabase>();

    List<Folder> currentFolders = db.currentFolders;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => widget.onBottomSheetClosed(),
      child: BottomSheet(
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        onClosing: () {},
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
      
                // Pin
                IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: Transform.rotate(
                    angle: pinAngle,
                    child: const Icon(Icons.push_pin)
                  ),
                  onPressed: () {
                    if (widget.note != null) pinAction(widget.note!.id);
                    if (widget.folder != null) pinAction(widget.folder!.id);
                  }
                ),
      
                // Folder
                if (widget.note != null) IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: const Icon(Icons.folder),
                  onPressed: () {
                    addToFolder(currentFolders);
                  }
                ),
      
                // Edit
                if (widget.folder != null) IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editFolder();
                  }
                ),

                // Discard from the current folder
                if (widget.note != null && widget.allowNoteFromFolderDeletion == true) IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: const Icon(
                    Icons.folder_off
                  ),
                  onPressed: () {
                    context.read<NotesDatabase>().deleteNoteFromFolder(widget.note!.id);

                    Navigator.pop(context);
                  }
                ),
      
                // Delete
                IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteItem();
                  }
                )
              ]
            )
          );
        }
      )
    );
  }
}