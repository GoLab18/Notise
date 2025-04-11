import 'package:flutter/material.dart';
import 'package:notise/components/button_template.dart';

class AddEditFolderWindow extends StatelessWidget {
  final String actionTitle;
  final String sumbitButtonName;
  
  final TextEditingController folderNameController;

  final VoidCallback onAddPressed;
  final VoidCallback onCancelPressed;

  final FocusNode fcsNode = FocusNode();

  AddEditFolderWindow({
    super.key,
    required this.actionTitle,
    required this.sumbitButtonName,
    required this.folderNameController,
    required this.onAddPressed,
    required this.onCancelPressed
  });

  @override
  Widget build(BuildContext context) {
    fcsNode.requestFocus();

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: SizedBox(
        width: 200,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            
            // Data column
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  // Action title
                  Text(
                    actionTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 20
                    )
                  ),
        
                  // Folder name
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 6),
                    child: TextField(
                      focusNode: fcsNode,
                      controller: folderNameController,
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
                        hintText: "Name..",
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary
                        )
                      )
                    )
                  )
                ]
              )
            ),
        
            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonTemplate(
                  text: "Cancel",
                  onPressed: onCancelPressed
                ),
                ButtonTemplate(
                  text: sumbitButtonName,
                  onPressed: onAddPressed
                )
              ]
            )
          ]
        )
      )
    );
  }
}