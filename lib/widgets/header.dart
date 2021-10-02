import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isFeed = false, String titile = 'Profile'}) {
  return AppBar(
    title: Text(
      isFeed ? 'ReachMe' : titile,
      style: TextStyle(
        fontSize: isFeed ? 50 : 22,
        fontFamily: isFeed ? 'Signatra' : '',
        color: Colors.white,
      ),
    ),
    centerTitle: isFeed ? true : false,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
