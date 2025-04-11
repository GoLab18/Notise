import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/notes_database.dart';
import '../pages/folders_view_page.dart';
import '../pages/notes_view_page.dart';

class SearchOverlay extends StatefulWidget {
  final int currIndex;
  final VoidCallback onClose;

  const SearchOverlay({
    super.key,
    required this.currIndex,
    required this.onClose
  });

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  double opacity = 0.0;
  late FocusNode fcsNode;
  late TextEditingController txtEdtController;
  String query = "";

  @override
  void initState() {
    super.initState();

    fcsNode = FocusNode()..requestFocus();
    txtEdtController = TextEditingController();

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() { opacity = 1.0; });
    });
  }

  @override
  void dispose() {
    fcsNode.dispose();
    super.dispose();
  }

  void overlayClosedCallback() {
    widget.onClose();
    context.read<NotesDatabase>().clearSearchResults(widget.currIndex == 0);
  }

  void invokeSearch(BuildContext context) {
    (widget.currIndex == 0)
      ? context.read<NotesDatabase>().searchNotes(query)
      : context.read<NotesDatabase>().searchFolders(query);
  }
  
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        overlayClosedCallback();
      },
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    width: 1.0
                  )
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
                    blurRadius: 8
                  )
                ]
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: BackButton(
                  onPressed: overlayClosedCallback
                ),
                title: TextField(
                  controller: txtEdtController,
                  focusNode: fcsNode,
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary
                    ),
                    border: InputBorder.none
                  ),
                  onChanged: (qry) {
                    query = qry;
                    invokeSearch(context);
                  }
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      txtEdtController.text = "";
                      query = txtEdtController.text;

                      invokeSearch(context);
                    },
                    icon: Icon(Icons.close)
                  )
                ]
              )
            )
          ),
          body: SizedBox.expand(
            child: widget.currIndex == 0
              ? NotesViewPage(
                isInSearchMode: true,
                onScrollMaxExtentReached: () {
                  context.read<NotesDatabase>().searchNotes(query, false);
                }
              )
              : FoldersViewPage(
                isInSearchMode: true,
                onScrollMaxExtentReached: () {
                  context.read<NotesDatabase>().searchFolders(query, false);
                }
              )
          )
        )
      )
    );
  }
}