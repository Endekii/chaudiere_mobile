import 'package:chaudiere_mobile/providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/screens/events_master.dart';
import 'package:provider/provider.dart';

class ChaudiereApp extends StatefulWidget {
  const ChaudiereApp({super.key});

  @override
  State<ChaudiereApp> createState() => _ChaudiereAppState();
}

class _ChaudiereAppState extends State<ChaudiereApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Chaudière',
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chaudière'),
          actions: [
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        body: EventsMaster(),
        ),
      );
  }
}