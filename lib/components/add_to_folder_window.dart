import 'package:flutter/material.dart';
import 'package:notise/components/button_template.dart';
import 'package:notise/data/folder.dart';
import 'package:notise/data/note.dart';
import 'package:notise/data/notes_database.dart';
import 'package:provider/provider.dart';

class AddToFolderWindow extends StatefulWidget {
  final Note note;
  final List<Folder> currentFolders;
  final void Function()? popPreviusWindow;

  const AddToFolderWindow({
    super.key,
    required this.note,
    required this.currentFolders,
    this.popPreviusWindow
  });

  @override
  State<AddToFolderWindow> createState() => _AddToFolderWindowState();
}

class _AddToFolderWindowState extends State<AddToFolderWindow> {
  int? _selectedFolderId;

  bool isErrorVisible = false;


  void addOrShowError() {
    if (_selectedFolderId != null) {
        if (widget.note.folderId == _selectedFolderId) {
          setState(() {
            isErrorVisible = true;
          });
        } else {
          context.read<NotesDatabase>().addNoteToFolder(
            widget.note.id,
            _selectedFolderId!,
            null
          );

          Navigator.pop(context);
          if (widget.popPreviusWindow != null) widget.popPreviusWindow!();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 9, 61, 140),
      content: Container(
        width: 200,
        height: 180,
        decoration:  const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            // Action title
            const Text(
              "Add to folder..",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),

            // Folders available
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Column(
                children: [
                  DropdownMenu<Folder>(
                    onSelected: (Folder? value) {
                      setState(() {
                        if (value != null) {
                          if (isErrorVisible && _selectedFolderId != value.id) {
                              isErrorVisible = false;
                          }

                          _selectedFolderId = value.id;
                        }
                      });
                    },
                    expandedInsets: EdgeInsets.zero,
                    leadingIcon: const Icon(
                      Icons.folder,
                      color: Colors.white,
                      size: 18,
                    ),
                    trailingIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    selectedTrailingIcon: const Icon(
                      Icons.arrow_drop_up,
                      color: Colors.white
                    ),
                    textStyle: const TextStyle(color: Colors.white),
                    menuStyle: const MenuStyle(
                      surfaceTintColor: WidgetStatePropertyAll(Color.fromARGB(255, 44, 4, 67)),
                      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 9, 61, 140))
                    ),
                    dropdownMenuEntries: widget.currentFolders.map<DropdownMenuEntry<Folder>>((Folder folder) {
                      return DropdownMenuEntry<Folder>(
                        value: folder,
                        label: folder.name,
                        labelWidget: Text(
                          folder.name,
                          style: const TextStyle(
                            color: Colors.white
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                        )
                      );
                    }).toList()
                  ),

                  // Error text
                  SizedBox(
                    height: 20,
                    child: Visibility(
                      visible: isErrorVisible,
                      child: Text(
                        "Note is already inside the folder!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red.shade800
                        )
                      )
                    ),
                  )
                ],
              ),
            ),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonTemplate(
                  text: "Add",
                  onPressed: addOrShowError
                ),
                ButtonTemplate(
                  text: "Cancel",
                  onPressed: () {
                  Navigator.pop(context);
                  if (widget.popPreviusWindow != null) widget.popPreviusWindow!();
                })
              ]
            )
          ]
        )
      )
    );
  }
}