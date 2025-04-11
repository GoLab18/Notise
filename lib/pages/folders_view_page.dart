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
  final bool isInSearchMode;
  final VoidCallback? onBottomSheetOpened;
  final VoidCallback? onBottomSheetClosed;
  final VoidCallback? onScrollMaxExtentReached;

  const FoldersViewPage({
    super.key,
    this.isInSearchMode = false,
    this.onBottomSheetOpened,
    this.onBottomSheetClosed,
    this.onScrollMaxExtentReached
  });

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

  ScrollController? scrlController;

  @override
  void initState() {
    super.initState();

    if (widget.isInSearchMode) {
      scrlController = ScrollController()..addListener(() {
        if (scrlController!.position.pixels >= scrlController!.position.maxScrollExtent * 7/10) {
          widget.onScrollMaxExtentReached!();
        }
      });
    }
  }

  void holdInteraction(int index, Folder folder) {
    setState(() {
      _scales[index] = _scalePressed;
      _durationsMs[index] = _durationDefault;
    });

    _longPressTimer = Timer(
      Duration(
        seconds: _onHoldBottomSheetOpenTime
      ),
      () {
        if (widget.onBottomSheetOpened != null) widget.onBottomSheetOpened!();

        if (!widget.isInSearchMode) {
          final bottomSheetController = showBottomSheet(
            context: context,
            builder: (BuildContext context) => CustomBottomSheet(
              folder: folder,
              onBottomSheetClosed: widget.onBottomSheetClosed!
            )
          );

          bottomSheetController.closed.whenComplete(widget.onBottomSheetClosed!);
        }
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
    List<Folder> currentFolders = (widget.isInSearchMode) ? db.currFoldersSearch : db.currentFolders;
    
    return CustomScrollView(
      controller: scrlController,
      shrinkWrap: true,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
          sliver: SliverList.builder(
            itemCount: currentFolders.length,
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
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.folder,
                            color: Theme.of(context).colorScheme.inversePrimary
                          ),
          
                          // Folder name
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                currentFolders[index].name,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 20
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
                                    child: Icon(
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                      Icons.push_pin_outlined,
                                      size: 14
                                    )
                                  )
                                ),
                                
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 6),
                                        child: Icon(
                                          Icons.note_outlined,
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          size: 14
                                        )
                                      ),
                          
                                      // Amount of notes inside
                                      Text(
                                        currentFolders[index].notesCount.toString(),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          fontSize: 12
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
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
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
          )
        ),

        if (currentFolders.isNotEmpty) SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Divider(
              color: Theme.of(context).colorScheme.inversePrimary,
              thickness: 2,
              height: 2
            )
          )
        ),

        if (currentFolders.isNotEmpty) SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 72.0),
            child: Divider(
              color: Theme.of(context).colorScheme.inversePrimary,
              thickness: 2,
              height: 2
            )
          )
        ),

        SliverToBoxAdapter(child: const SizedBox(height: 8.0)),

        if (!widget.isInSearchMode) SliverToBoxAdapter(
          child: SizedBox(height: 60)
        )
      ]
    );
  }
}