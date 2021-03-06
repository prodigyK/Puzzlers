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
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Candal',
        ),
        home: MainScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/play-screen':
              return PageTransition(
                child: PlayScreen(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                settings: settings,
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
