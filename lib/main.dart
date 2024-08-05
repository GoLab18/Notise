import 'package:flutter/material.dart';
import 'package:notise/data/notes_database.dart';
import 'package:notise/pages/notes_page.dart';
import 'package:notise/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.initialization();

  runApp(
    MultiProvider(
      providers: [

        // Database provider
        ChangeNotifierProvider(
          create: (context) => NotesDatabase()
        ),

        // Themes provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider()
        )
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData
    );
  }
}