import 'package:flutter/material.dart';
import 'package:notise/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        
                // Dark mode text
                Text(
                  "Dark mode",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary
                  )
                ),

                // Dark mode switch
                Switch(
                  value: Provider.of<ThemeProvider>(
                    context,
                    listen: false
                  ).isDarkMode,
                  onChanged: (bool isChanged) =>
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false
                  ).toggleTheme()
                )
              ]
            )
          ]
        ),
      )
    );
  }
}