import 'package:flutter/material.dart';
import 'package:notes_app/data/folder.dart';
import 'package:notes_app/data/notes_database.dart';
import 'package:provider/provider.dart';

class FoldersViewPage extends StatefulWidget {
  const FoldersViewPage({super.key});

  @override
  State<FoldersViewPage> createState() => _FoldersViewPageState();
}

class _FoldersViewPageState extends State<FoldersViewPage> {
  @override
  Widget build(BuildContext context) {
    final NotesDatabase db = context.watch<NotesDatabase>();

    List<Folder> currentFolders = db.currentFolders;
    
    return ListView.builder(
      itemCount: currentFolders.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            tileColor: Colors.blue.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            leading: const Icon(
              Icons.folder,
              color: Colors.white,
            ),
            textColor: Colors.white,
            title: Text(
              currentFolders[index].name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
            titleAlignment: ListTileTitleAlignment.center
          ),
        );
      }
    );
  }
}