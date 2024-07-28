import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/components/add_folder_window.dart';
import 'package:notes_app/components/add_to_folder_window.dart';
import 'package:notes_app/data/folder.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/data/notes_database.dart';
import 'package:provider/provider.dart';

class CustomBottomSheet extends StatefulWidget {
  final Note? note;
  final Folder? folder;

  const CustomBottomSheet({
    super.key,
    this.note,
    this.folder
  }) : assert(note != null || folder != null, 'At least one item must be provided');

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
  

  void pinAction(int noteId) {
    setState(() {
      pinAngle = (pinAngle == pi / 4) ? 0 : pi / 4;
    });

    context.read<NotesDatabase>().changeNotePinStatus(noteId);

    fetchItems();

    Navigator.pop(context);
  }

  void deleteItem(int id) {
    Navigator.pop(context);

    context.read<NotesDatabase>().deleteNote(id);
  }

  void fetchItems() {
    context.read<NotesDatabase>().fetchNotes();
  }

  void addToFolder(List<Folder> currentFolders) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => currentFolders.isNotEmpty
        ? AddToFolderWindow(
          noteId: widget.note!.id,
          currentFolders: currentFolders,
          popPreviusWindow: () {
            Navigator.pop(context);
          }
        )
        : AddFolderWindow(
          folderNameController: folderNameController,
          onAddPressed: () {
            dialogContext.read<NotesDatabase>().addNoteToFolder(
              widget.note!.id,
              null,
              folderNameController.text
            );

            folderNameController.clear();

            Navigator.pop(dialogContext);
            Navigator.pop(context);
          },
          onCancelPressed: () {
            folderNameController.clear();

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

    return BottomSheet(
      backgroundColor: const Color.fromARGB(255, 34, 2, 52),
      onClosing: () {},
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // Pin
              IconButton(
                color: Colors.white,
                icon: Transform.rotate(
                  angle: pinAngle,
                  child: const Icon(Icons.push_pin)
                ),
                onPressed: () {
                  pinAction(widget.note?.id ?? widget.folder!.id);
                }
              ),

              // Folder
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.folder),
                onPressed: () {
                  addToFolder(currentFolders);                  
                }
              ),

              // Delete
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.delete),
                onPressed: () {}
              )
            ]
          )
        );
      }
    );
  }
}