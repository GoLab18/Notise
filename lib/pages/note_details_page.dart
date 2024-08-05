import 'package:flutter/material.dart';
import 'package:notise/components/main_app_bar.dart';
import 'package:notise/data/note.dart';
import 'package:notise/data/notes_database.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MainAppBar(
        showBackButton: true,
        isInEditState: isInEditState,
        onEditStateFinished: onEditStateFinished,
        popupMenuOptionsCallbacks: {
          "Delete": () {
            context.read<NotesDatabase>().deleteNote(widget.note);
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
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
                overflow: TextOverflow.ellipsis
              ),
              cursorColor: Theme.of(context).colorScheme.inversePrimary,
              backgroundCursorColor: Theme.of(context).colorScheme.tertiary
            )
          ),

          Divider(
            color: Theme.of(context).colorScheme.inversePrimary,
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
                style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.tertiary,
                  overflow: TextOverflow.ellipsis
                ),
                cursorColor: Theme.of(context).colorScheme.inversePrimary,
                backgroundCursorColor: Theme.of(context).colorScheme.tertiary,
                maxLines: null
              ),
            ),
          )
        ]
      )
    );
  }
}
