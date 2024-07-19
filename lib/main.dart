import 'package:flutter/material.dart';
import 'package:notes_app/data/notes_database.dart';
import 'package:notes_app/pages/notes_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.initialization();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NotesDatabase(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage()
    );
  }
}