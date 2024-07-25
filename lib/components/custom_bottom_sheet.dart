import 'dart:math';

import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  double pinAngle = pi / 4;

  void pinAction() {
    setState(() {
      pinAngle = (pinAngle == pi / 4) ? 0 : pi / 4;
    });
  }

  void addToFolder() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Container(
            width: 200,
            height: 300,
            decoration:  const BoxDecoration(),
            child: const Column(

            )
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Colors.black,
      onClosing: () {},
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // Pin
              IconButton(
                color: Colors.white,
                icon: Transform.rotate(
                  angle: pinAngle,
                  child: const Icon(Icons.push_pin)
                ),
                onPressed: pinAction
              ),

              // Folder
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.folder),
                onPressed: () {}
              ),

              // Delete
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.delete),
                onPressed: () {}
              )
            ]
          )
        );
      }
    );
  }
}