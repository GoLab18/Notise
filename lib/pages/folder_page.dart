import 'package:flutter/material.dart';
import 'package:notise/components/add_note_window.dart';
import 'package:notise/components/custom_floating_action_button.dart';
import 'package:notise/components/main_app_bar.dart';
import 'package:notise/data/folder.dart';
import 'package:notise/data/notes_database.dart';
import 'package:notise/pages/notes_view_page.dart';
import 'package:notise/util/date_util.dart';
import 'package:provider/provider.dart';

class FolderPage extends StatefulWidget {
  final Folder folder;

  const FolderPage({
    super.key,
    required this.folder
  });

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late TextEditingController _folderNameController;
  late FocusNode _folderNameFocusNode;
  late bool isInEditState;

  // For disabling UI parts on bottom sheet opening
  late bool _isBottomSheetOpen;

  late TextEditingController titleController;
  late TextEditingController textController;

  late final Stream<Folder?> folderStream;

  @override
  void initState() {
    super.initState();

    _folderNameController = TextEditingController(text: widget.folder.name);
    _folderNameFocusNode = FocusNode();
    isInEditState = false;
    _isBottomSheetOpen = false;
    _folderNameFocusNode.addListener(handleFocusChange);

    titleController = TextEditingController();
    textController = TextEditingController();

    folderStream = context.read<NotesDatabase>().fetchFolderStream(widget.folder.id);
  }

  void handleFocusChange() {
    setState(() {
      isInEditState = _folderNameFocusNode.hasFocus;
    });
  }

  void onEditStateFinished() {
    setState(() {
      _folderNameFocusNode.unfocus();

      updateFolder(
        widget.folder.id,
        _folderNameController.text
      );

      isInEditState = false;
    });
  }

  void updateFolder(int id, String newFolderName) {
    context.read<NotesDatabase>().updateFolder(id, newFolderName);
  }

  void deleteFolder(int id) {
    context.read<NotesDatabase>().deleteFolder(id);
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AddNoteWindow(
          titleController: titleController,
          textController: textController,
          onAddPressed:  () {
            context.read<NotesDatabase>().addNote(titleController.text, textController.text, widget.folder.id);

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
  
  @override
  void dispose() {
    _folderNameController.dispose();
    _folderNameFocusNode.removeListener(handleFocusChange);
    _folderNameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Folder?>(
      stream: folderStream,
      initialData: widget.folder,
      builder: (context, snapshot) {
        Folder? folder = snapshot.data;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: MainAppBar(
            showBackButton: true,
            isInEditState: isInEditState,
            onEditStateFinished: onEditStateFinished,
            popupMenuOptionsCallbacks: {
              "Delete": () {
                deleteFolder(folder!.id);
              }
            }
          ),
          body: Column(
            children: [
              // Note title
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Editable folder name
                    EditableText(
                      keyboardType: TextInputType.multiline,
                      controller: _folderNameController,
                      focusNode: _folderNameFocusNode,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        overflow: TextOverflow.ellipsis
                      ),
                      cursorColor: Theme.of(context).colorScheme.inversePrimary,
                      backgroundCursorColor: Theme.of(context).colorScheme.tertiary
                    ),
                    
                    Row(
                      children: [
        
                        // Init date
                        Text(
                          DateUtil.getCurrentDate(folder!.initDate),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 14
                          )
                        ),
        
                        // Notes
                        Padding(
                          padding: const EdgeInsets.only(left: 14, right: 6),
                          child: Icon(
                            Icons.note_outlined,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 16,
                          )
                        ),
            
                        // Amount of notes inside
                        Text(
                          folder.notesCount.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 14
                          ),
                          textAlign: TextAlign.center
                        )
                      ]
                    )
                  ]
                )
              ),
        
              Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
                thickness: 2,
                height: 0
              ),
        
              // List for notes
              Expanded(
                child: NotesViewPage(
                  onBottomSheetOpened: () {
                    setState(() {
                      _isBottomSheetOpen = true;
                    });
                  },
                  onBottomSheetClosed: () {
                    setState(() {
                      _isBottomSheetOpen = false;
                    });
                  },
                  viewSpecificFolderNotes: true,
                  folderId: folder.id
                )
              )
            ]
          ),
          floatingActionButton: Visibility(
            visible: !_isBottomSheetOpen,
            child: CustomFloatingActionButton(
              onPressed: createNote
            )
          )
        );
      }
    );
  }
}