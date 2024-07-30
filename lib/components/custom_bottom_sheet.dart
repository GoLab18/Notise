import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notise/components/add_folder_window.dart';
import 'package:notise/components/add_to_folder_window.dart';
import 'package:notise/data/folder.dart';
import 'package:notise/data/note.dart';
import 'package:notise/data/notes_database.dart';
import 'package:provider/provider.dart';

class CustomBottomSheet extends StatefulWidget {
  final Note? note;
  final Folder? folder;
  final VoidCallback onBottomSheetClosed;

  const CustomBottomSheet({
    super.key,
    this.note,
    this.folder,
    required this.onBottomSheetClosed
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

  void deleteItem(int id) {
    if (widget.note != null) context.read<NotesDatabase>().deleteNote(id);
    if (widget.folder != null) context.read<NotesDatabase>().deleteFolder(id);

    widget.onBottomSheetClosed();
    Navigator.pop(context);
  }

  void addToFolder(List<Folder> currentFolders) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => currentFolders.isNotEmpty
        ? AddToFolderWindow(
          noteId: widget.note!.id,
          currentFolders: currentFolders,
          popPreviusWindow: () {
            widget.onBottomSheetClosed();
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
    showDialog(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
        
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
                  if (widget.note != null) pinAction(widget.note!.id);
                  if (widget.folder != null) pinAction(widget.folder!.id);
                }
              ),

              // Folder
              if (widget.note != null) IconButton(
                color: Colors.white,
                icon: const Icon(Icons.folder),
                onPressed: () {
                  addToFolder(currentFolders);
                }
              ),

              // Edit
              if (widget.folder != null) IconButton(
                color: Colors.white,
                icon: const Icon(Icons.edit),
                onPressed: () {
                  editFolder();                  
                }
              ),

              // Delete
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  if (widget.note != null) deleteItem(widget.note!.id);
                  if (widget.folder != null) deleteItem(widget.folder!.id);
                }
              )
            ]
          )
        );
      }
    );
  }
}