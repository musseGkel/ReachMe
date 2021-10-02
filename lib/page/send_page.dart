import 'package:flutter/material.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Send Page'),
      ),
    );
  }
}
