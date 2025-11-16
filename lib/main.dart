import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_frontend/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      supportedLocales: [/*Locale('en'), */ Locale('de', 'AT')],
      // TODO: add your application's localizations delegates.
      localizationsDelegates: const [],
      builder: (ctx, child) {
        if (kDebugMode) {
          print(ctx);
        }
        return MaterialApp(home: child!);
      },
      routerConfig: goRouter,
    );
  }
}
