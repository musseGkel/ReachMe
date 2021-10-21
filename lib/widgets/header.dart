import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isFeed = false, String titile = 'Profile', backButton = true}) {
  return AppBar(
    automaticallyImplyLeading: backButton,
    title: Text(
      isFeed ? 'ReachMe' : titile,
      style: TextStyle(
        fontSize: isFeed ? 50 : 22,
        fontFamily: isFeed ? 'Signatra' : '',
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: isFeed ? true : false,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
