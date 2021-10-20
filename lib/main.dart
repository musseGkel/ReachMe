import 'package:flutter/material.dart';
import 'package:reach_me/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseFirestore.instance.settings(timestampInSnapshotsEnabled: true).then(
  //     (_) {
  //   print('Timestamps enabled in snpshots\n');
  // }, onError: () {
  //   print('there was an error enabling timestamp in snapshots');
  // });
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
