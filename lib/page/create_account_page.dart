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
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      SnackBar snackBar = SnackBar(
        content: Text('Welcome $username'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        duration: Duration(seconds: 2),
        shape: StadiumBorder(),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      Navigator.pop(context, username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titile: 'Create Account'),
      body: Builder(
        builder: (context) => ListView(
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
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.trim().length < 3 || value.isEmpty)
                      return 'Username to short';
                    else if (value.trim().length > 12)
                      return 'Username to long';
                    else
                      return null;
                  },
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
      ),
    );
  }
}
