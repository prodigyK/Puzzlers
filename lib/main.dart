import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/providers/update_puzzles.dart';
import 'package:puzzlers/providers/update_text_provider.dart';
import 'package:puzzlers/screens/play_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UpdatePuzzles()),
        ChangeNotifierProvider(create: (_) => UpdateTextProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PlayScreen(),
      ),
    );
  }
}
