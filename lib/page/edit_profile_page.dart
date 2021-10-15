import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/home_page.dart';
import 'package:reach_me/models/u/user.dart';
import 'package:reach_me/widgets/loadng.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user;
  bool isLoading = false;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isDisplayNameValid = true;
  bool isBioValid = true;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await userRef.doc(widget.currentUserId).get();
    user = User.deSerialize(doc);
    displayNameController.text = user!.displayName;
    bioController.text = user!.bio;
    setState(() {
      isLoading = false;
    });
  }

  buildDisplayName() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Display Name',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: 'update display name',
            errorText: isDisplayNameValid ? null : 'Name too short',
          ),
        ),
      ],
    );
  }

  buildBio() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Bio',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
              hintText: 'update Bio',
              errorText: isBioValid ? null : 'Bio too long'),
        ),
      ],
    );
  }

  updateProfile() {
    setState(() {
      if (displayNameController.text.trim().length < 3 ||
          displayNameController.text.isEmpty) {
        isDisplayNameValid = false;
      } else
        isDisplayNameValid = true;
      if (bioController.text.trim().length > 50)
        isBioValid = false;
      else
        isBioValid = true;
    });
    if (isDisplayNameValid && isBioValid) {
      userRef.doc(widget.currentUserId).update(
          {'name': displayNameController.text, 'bio': bioController.text});
    }
    SnackBar snackBar = SnackBar(
      content: Text('Profile updated'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      duration: Duration(seconds: 2),
      shape: StadiumBorder(),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.done))
          ],
        ),
        body: isLoading
            ? circularLoading()
            : ListView(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          CachedNetworkImageProvider(user!.photoUrl),
                    ),
                  ),
                  buildDisplayName(),
                  SizedBox(
                    height: 10,
                  ),
                  buildBio(),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        // width: 160,
                        //height: 40,
                        child: ElevatedButton(
                            onPressed: updateProfile,
                            child: Text('Update Profile')),
                      ),
                      TextButton(onPressed: logout, child: Text('Logout'))
                    ],
                  ),
                ],
              ));
  }
}
