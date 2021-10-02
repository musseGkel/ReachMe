import 'package:flutter/material.dart';

Container circularLoading() {
  return Container(
    padding: EdgeInsets.only(top: 5),
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}

Container linearLoading() {
  return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.purple),
      ));
}
