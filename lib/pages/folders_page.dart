import 'package:flutter/material.dart';

class FoldersPage extends StatelessWidget {
  const FoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Folders Page",
        style: TextStyle(color: Colors.white)
      )
    );
    // return ListView.builder(
    //   itemBuilder: (BuildContext context, int index) {

    //   }
    // );
  }
}