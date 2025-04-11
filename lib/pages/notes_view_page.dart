import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notise/components/custom_bottom_sheet.dart';
import 'package:notise/data/note.dart';
import 'package:notise/data/notes_database.dart';
import 'package:notise/pages/note_details_page.dart';
import 'package:notise/util/date_util.dart';
import 'package:provider/provider.dart';

class NotesViewPage extends StatefulWidget {
  // Bottom sheet related fields
  final VoidCallback onBottomSheetOpened;
  final VoidCallback onBottomSheetClosed;

  // Folder notes view related fields
  final bool viewSpecificFolderNotes;
  final int? folderId;

  const NotesViewPage({
    super.key,
    required this.onBottomSheetOpened,
    required this.onBottomSheetClosed,
    this.viewSpecificFolderNotes = false,
    this.folderId
  }) : assert(
    ((viewSpecificFolderNotes == true && folderId != null) || (viewSpecificFolderNotes == false && folderId == null)),
    'Both viewSpecificFolderNotes and folderId have to be either specified or not');

  @override
  State<NotesViewPage> createState() => _NotesViewPageState();
}

class _NotesViewPageState extends State<NotesViewPage> {
  final double _scaleDefault = 1.0;
  final double _scalePressed = 0.95;
  final int _durationDefault = 120;

  final Map<int, double> _scales = {};
  final Map<int, int> _durationsMs = {};

  final int _onHoldBottomSheetOpenTime = 1;
  late Timer? _longPressTimer;


  void holdInteraction(int index, Note note) {
    setState(() {
      _scales[index] = _scalePressed;
      _durationsMs[index] = _durationDefault;
    });

    _longPressTimer = Timer(
      Duration(
        seconds: _onHoldBottomSheetOpenTime
      ),
      () {
        widget.onBottomSheetOpened();
        final bottomSheetController = showBottomSheet(
          context: context,
          builder: (BuildContext context) => CustomBottomSheet(
            note: note,
            onBottomSheetClosed: widget.onBottomSheetClosed,
            allowNoteFromFolderDeletion: widget.viewSpecificFolderNotes
          )
        );

        bottomSheetController.closed.whenComplete(widget.onBottomSheetClosed);
      }
    );
  }

  void holdEnded(int index) {
    if (_longPressTimer != null && _longPressTimer!.isActive) {
      _longPressTimer!.cancel();
    }
    setState(() {
      _scales[index] = _scaleDefault;
      _durationsMs[index] = _durationDefault * 2;
    });
  }

  void onNoteClick(BuildContext context, int index, Note note) {
    setState(() {
      _scales[index] = _scalePressed;
      _durationsMs[index] = _durationDefault;
    });

    Future.delayed(Duration(milliseconds: _durationDefault), () {
      setState(() {
        _scales[index] = _scaleDefault;
      });

      // Redirect to the details page
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => NoteDetailsPage(
            note: note
          )
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final NotesDatabase db = context.watch<NotesDatabase>();

    List<Note> currentNotes;

    if (widget.viewSpecificFolderNotes) {
      currentNotes = db.currentNotes.where(
        (Note note) => note.folderId == widget.folderId
      ).toList();
    } else {
      currentNotes = db.currentNotes;
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        itemCount: currentNotes.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 140
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              onNoteClick(context, index, currentNotes[index]);
            },
            onLongPress: () {
              holdInteraction(index, currentNotes[index]);
            },
            onLongPressUp: () {
              holdEnded(index);
            },
            child: AnimatedScale(
              scale: _scales[index] ?? _scaleDefault,
              duration: Duration(milliseconds: _durationsMs[index] ?? _durationDefault),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note title
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                      child: Text(
                        currentNotes[index].title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1
                      )
                    ),
              
                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                      thickness: 2,
                      height: 0
                    ),
                    
                    // Note text
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          currentNotes[index].text,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          softWrap: true
                        )
                      )
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          // Date
                          Text(
                            DateUtil.getCurrentDate(currentNotes[index].initDate),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 12
                            )
                          ),
                      
                          // Is it pinned
                          Visibility(
                            visible: currentNotes[index].isPinned,
                            child: Transform.rotate(
                              angle: pi / 4,
                              child: Icon(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                Icons.push_pin_outlined,
                                size: 14
                              )
                            )
                          )
                        ]
                      )
                    )
                  ]
                )
              )
            )
          );
        }
      )
    );
  }
}
