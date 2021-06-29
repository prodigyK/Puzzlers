import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/providers/update_puzzles_provider.dart';
import 'package:puzzlers/providers/update_timer_provider.dart';
import 'package:puzzlers/screens/main_screen.dart';
import 'package:puzzlers/screens/play_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UpdatePuzzlesProvider()),
        ChangeNotifierProvider(create: (_) => UpdateTimerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/play-screen':
              return PageTransition(
                child: PlayScreen(),
                type: PageTransitionType.fade,
                settings: settings,
              );
              break;
            default:
              return null;
          }
        },
      ),
    );
  }
}
