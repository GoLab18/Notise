import 'package:flutter/material.dart';
import 'package:notes_app/components/button_template.dart';

class AddToFolderWindow extends StatelessWidget {
  final TextEditingController folderNameController;

  final VoidCallback onAddPressed;
  final VoidCallback onCancelPressed;

  const AddToFolderWindow({
    super.key,
    required this.folderNameController,
    required this.onAddPressed,
    required this.onCancelPressed
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade900,
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
                  const Text(
                    "New folder",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
        
                  // Folder name
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 6),
                    child: TextField(
                      controller: folderNameController,
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
                        hintText: "Name..",
                        hintStyle: TextStyle(
                          color: Colors.white70
                        )
                      )
                    ),
                  )
                ]
              ),
            ),
        
            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonTemplate(
                  text: "Create",
                  onPressed: onAddPressed
                ),
                ButtonTemplate(
                  text: "Cancel",
                  onPressed: onCancelPressed
                )
              ]
            )
          ]
        ),
      )
    );
  }
}