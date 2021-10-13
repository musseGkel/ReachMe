import 'package:flutter/material.dart';
import 'package:reach_me/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.deepPurple),
      ),
      title: 'Reach Me',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
