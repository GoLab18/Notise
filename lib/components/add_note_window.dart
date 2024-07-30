import 'package:flutter/material.dart';
import 'package:notise/components/button_template.dart';

class AddNoteWindow extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController textController;

  final VoidCallback onAddPressed;
  final VoidCallback onCancelPressed;

  const AddNoteWindow({
    super.key,
    required this.titleController,
    required this.textController,
    required this.onAddPressed,
    required this.onCancelPressed
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.blue.shade900,
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.5,
          maxWidth: screenSize.width * 0.7
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            // Data column
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  // Action title
                  const Text(
                    "New note",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
        
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 6),
                    child: TextField(
                      controller: titleController,
                      style: const TextStyle(
                        color: Colors.white
                      ),
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(255, 9, 61, 140),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: Colors.white
                            )
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              color: Colors.white
                            )
                        ),
                        hintText: "Title..",
                        hintStyle: TextStyle(
                          color: Colors.white70
                        )
                      )
                    ),
                  ),
                  
                  // Text
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                      child: TextField(
                        controller: textController,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                          color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 9, 61, 140),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Colors.white
                            )
                          ),
                          hintText: "Note..",
                          hintStyle: TextStyle(
                            color: Colors.white70
                          ),
                          alignLabelWithHint: true,
                          hintTextDirection: TextDirection.ltr,
                          floatingLabelAlignment: FloatingLabelAlignment.start
                        )
                      )
                    ),
                  ),
                ]
              ),
            ),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonTemplate(text: "Create", onPressed: onAddPressed),
                ButtonTemplate(text: "Cancel", onPressed: onCancelPressed)
              ]
            )
          ]
        )
      )
    );
  }
}