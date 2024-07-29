import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/components/custom_bottom_sheet.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/data/notes_database.dart';
import 'package:notes_app/pages/note_details_page.dart';
import 'package:notes_app/util/date_util.dart';
import 'package:provider/provider.dart';

class NotesViewPage extends StatefulWidget {
  const NotesViewPage({super.key});

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
      () => showBottomSheet(
        context: context,
        builder: (BuildContext context) => CustomBottomSheet(
          note: note
        )
      )
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

    List<Note> currentNotes = db.currentNotes;

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
                  color: Colors.blue.shade900,
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.blue.shade900
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1
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
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          currentNotes[index].text,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          softWrap: true
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          // Date
                          Text(
                            DateUtil.getCurrentDate(currentNotes[index].initDate),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12
                            )
                          ),
                      
                          // Is it pinned
                          Visibility(
                            visible: currentNotes[index].isPinned,
                            child: Transform.rotate(
                              angle: pi / 4,
                              child: const Icon(
                                color: Colors.white,
                                Icons.push_pin_outlined,
                                size: 14,
                              )
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
                )
              ),
            ),
          );
        }
      ),
    );
  }
}
