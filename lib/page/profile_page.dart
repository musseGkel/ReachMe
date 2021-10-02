import 'package:flutter/material.dart';
import 'package:reach_me/widgets/header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titile: 'Profile'),
      body: Center(
        child: Container(
          child: Text('Profile Page'),
        ),
      ),
    );
  }
}
