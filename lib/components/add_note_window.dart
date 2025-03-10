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

    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: SizedBox(
            height: screenSize.height * 0.5,
            width: screenSize.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                // Data column
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                      // Action title
                      Text(
                        "New note",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 20
                        ),
                      ),
            
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 6),
                        child: TextField(
                          controller: titleController,
                          cursorColor: Theme.of(context).colorScheme.inversePrimary,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary
                          ),
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).colorScheme.surface,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.inversePrimary
                                )
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.inversePrimary
                                )
                            ),
                            hintText: "Title..",
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary
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
                            cursorColor: Theme.of(context).colorScheme.inversePrimary,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary
                            ),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.surface,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.inversePrimary
                                )
                              ),
                              hintText: "Note..",
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonTemplate(text: "Cancel", onPressed: onCancelPressed),
                    ButtonTemplate(text: "Create", onPressed: onAddPressed)
                  ]
                )
              ]
            )
          )
        )
      )
    );
  }
}