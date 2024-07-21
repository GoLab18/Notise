import 'package:flutter/material.dart';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/data/notes_database.dart';
import 'package:provider/provider.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final double _scaleDefault = 1.0;
  final double _scalePressed = 0.95;
  final int _durationDefault = 120;

  final Map<int, double> _scales = {};
  final Map<int, int> _durationsMs = {};


  void onNoteClick(int index) {
    setState(() {
      _scales[index] = _scalePressed;
      _durationsMs[index] = _durationDefault;
    });

    Future.delayed(Duration(milliseconds: _durationDefault), () {
      setState(() {
        _scales[index] = _scaleDefault;
      });
    });
  }

  void holdInteraction(int index) {
    setState(() {
    _scales[index] = _scalePressed;
    _durationsMs[index] = _durationDefault;
    });
  }

  void holdEnded(int index) {
    setState(() {
    _scales[index] = _scaleDefault;
    _durationsMs[index] = _durationDefault * 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<NotesDatabase>();

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
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onNoteClick(index);
            },
            onTapDown: (TapDownDetails details) {
              holdInteraction(index);
            },
            onTapUp: (TapUpDetails details) {
              holdEnded(index);
            },
            onTapCancel: () {
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
                          maxLines: 5,
                          softWrap: true
                        ),
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
