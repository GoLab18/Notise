import 'package:flutter/material.dart';
import 'package:notes_app/components/main_app_bar.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/data/notes_database.dart';
import 'package:provider/provider.dart';

class NoteDetailsPage extends StatefulWidget {
  final Note note;

  const NoteDetailsPage({
    super.key,
    required this.note
  });

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  late FocusNode _titleFocusNode;
  late FocusNode _textFocusNode;
  late bool isInEditState;


  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note.title);
    _textController = TextEditingController(text: widget.note.text);
    _titleFocusNode = FocusNode();
    _textFocusNode = FocusNode();
    isInEditState = false;
    _titleFocusNode.addListener(handleFocusChange);
    _textFocusNode.addListener(handleFocusChange);
  }

  void handleFocusChange() {
    setState(() {
      isInEditState = _titleFocusNode.hasFocus || _textFocusNode.hasFocus;
    });
  }

  void onEditStateFinished() {
    setState(() {
      _titleFocusNode.unfocus();
      _textFocusNode.unfocus();

      updateNote(
        widget.note.id,
        _titleController.text,
        _textController.text,
      );

      isInEditState = false;
    });
  }

  void updateNote(int id, String? newTitle, String? newText) {
    context.read<NotesDatabase>().updateNote(id, newTitle, newText);
  }

  void deleteNote(int id) {
    context.read<NotesDatabase>().deleteNote(id);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _titleFocusNode.removeListener(handleFocusChange);
    _textFocusNode.removeListener(handleFocusChange);
    _titleFocusNode.dispose();
    _textFocusNode.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      appBar: MainAppBar(
        showBackButton: true,
        isInEditState: isInEditState,
        onEditStateFinished: onEditStateFinished,
        popupMenuOptionsCallbacks: {
          "Delete": () {
            deleteNote(widget.note.id);
          }
        },
      ),
      body: Column(
        children: [

          // Note title
          Padding(
            padding: const EdgeInsets.all(10),
            child: EditableText(
              keyboardType: TextInputType.multiline,
              controller: _titleController,
              focusNode: _titleFocusNode,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                overflow: TextOverflow.ellipsis
              ),
              cursorColor: Colors.blue,
              backgroundCursorColor: Colors.grey,
            ),
          ),

          const Divider(
            color: Colors.white,
            thickness: 2,
            height: 0
          ),

          // Note text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: EditableText(
                keyboardType: TextInputType.multiline,
                controller: _textController,
                focusNode: _textFocusNode,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white70,
                  overflow: TextOverflow.ellipsis
                ),
                cursorColor: Colors.blue,
                backgroundCursorColor: Colors.grey,
                maxLines: null
              ),
            ),
          )
        ]
      )
    );
  }
}
