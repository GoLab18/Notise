import 'package:flutter/material.dart';
import 'package:notise/data/notes_database.dart';
import 'package:notise/pages/home_page.dart';
import 'package:notise/themes/theme_provider.dart';
import 'package:notise/util/orientation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.initialization();
  await ThemeProvider.loadThemePreference();

  await lockPhoneOrientationVertical();

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
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData
    );
  }
}