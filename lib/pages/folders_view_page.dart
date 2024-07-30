import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notise/components/custom_bottom_sheet.dart';
import 'package:notise/data/folder.dart';
import 'package:notise/data/notes_database.dart';
import 'package:notise/pages/folder_page.dart';
import 'package:notise/util/date_util.dart';
import 'package:provider/provider.dart';

class FoldersViewPage extends StatefulWidget {
  const FoldersViewPage({super.key});

  @override
  State<FoldersViewPage> createState() => _FoldersViewPageState();
}

class _FoldersViewPageState extends State<FoldersViewPage> {
  final double _scaleDefault = 1.0;
  final double _scalePressed = 0.95;
  final int _durationDefault = 120;

  final Map<int, double> _scales = {};
  final Map<int, int> _durationsMs = {};

  final int _onHoldBottomSheetOpenTime = 1;
  late Timer? _longPressTimer;


  void holdInteraction(int index, Folder folder) {
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
          folder: folder
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

  void onNoteClick(BuildContext context, int index, Folder folder) {
    setState(() {
      _scales[index] = _scalePressed;
      _durationsMs[index] = _durationDefault;
    });

    Future.delayed(Duration(milliseconds: _durationDefault), () {
      setState(() {
        _scales[index] = _scaleDefault;
      });

      // Redirect to the folder page
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => FolderPage(
            folder: folder
          )
        )
      );
    });
  }

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
          child: GestureDetector(
            onTap: () {
              onNoteClick(context, index, currentFolders[index]);
            },
            onLongPress: () {
              holdInteraction(index, currentFolders[index]);
            },
            onLongPressUp: () {
              holdEnded(index);
            },
            child: AnimatedScale(
              scale: _scales[index] ?? _scaleDefault,
              duration: Duration(milliseconds: _durationsMs[index] ?? _durationDefault),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.folder,
                      color: Colors.white,
                    ),

                    // Folder name
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          currentFolders[index].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                        )
                      )
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                          // Is it pinned
                          Visibility(
                            visible: currentFolders[index].isPinned,
                            child: Transform.rotate(
                              angle: pi / 4,
                              child: const Icon(
                                color: Colors.white,
                                Icons.push_pin_outlined,
                                size: 14,
                              )
                            )
                          ),
                          
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8, right: 6),
                                  child: Icon(
                                    Icons.note_outlined,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                ),
                    
                                // Amount of notes inside
                                Text(
                                  currentFolders[index].notesIds.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center
                                )
                              ]
                            )
                          ]
                        ),
                    
                        // Folder init date
                        Expanded(
                          child: Text(
                            DateUtil.getCurrentDate(currentFolders[index].initDate),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12
                            )
                          )
                        )
                      ]
                    )
                  ]
                )
              )
            )
          )
        );
      }
    );
  }
}