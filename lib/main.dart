import 'package:chaudiere_mobile/chaudiere_app.dart';
import 'package:chaudiere_mobile/providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: ChaudiereApp(),
  ));
}