import 'package:flutter/material.dart';

class ActivityLog extends StatefulWidget {
  const ActivityLog({Key? key}) : super(key: key);

  @override
  _ActivityLogState createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Activity Log'),
      ),
    );
  }
}
