import 'package:flutter/material.dart';
import 'package:reach_me/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();

  late var username;

  submit() {
    _formKey.currentState?.save();
    Navigator.pop(context, username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titile: 'Create Account'),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              'Create a username',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: TextFormField(
                onSaved: (value) => username = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter your username',
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: submit,
            child: Container(
              margin: EdgeInsets.all(15),
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
