import 'package:flutter/material.dart';
import 'package:notise/data/folder.dart';

class FolderPage extends StatefulWidget {
  final Folder folder;

  const FolderPage({
    super.key,
    required this.folder
  });

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Text("Folder page")
    );
  }
}