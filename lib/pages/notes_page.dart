import 'package:flutter/material.dart';
import 'package:notes_app/components/add_note_window.dart';
import 'package:notes_app/components/custom_floating_action_button.dart';
import 'package:notes_app/components/notes_view.dart';
import 'package:notes_app/data/notes_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    readNotes();
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

  void readNotes() {
    context.read<NotesDatabase>().fetchNotes();
  }

  void updateNote() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 4, 67),
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        centerTitle: true
      ),
      floatingActionButton: CustomFloatingActionButton(onPressed: createNote),
      body: const NotesView()
    );
  }
}