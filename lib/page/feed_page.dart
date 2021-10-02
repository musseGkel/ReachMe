import 'package:flutter/material.dart';
import 'package:reach_me/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // List<dynamic> users = [];
  // @override
  // void initState() {
  //   super.initState();
  //   // getUsers();
  //   //getUserById();
  //   // createUser();
  //   // updateUser();
  //   deleteUser();
  // }

  // void createUser() {
  //   userRef.doc('FXW7cCdxPuSr4exwJf').set({
  //     'username': 'ezu',
  //     'postCount': 12,
  //     'isAdmin': false,
  //   });
  // }

  // Future<void> updateUser() async {
  //   final doc = await userRef.doc('FXW7cCdxPuSr4exwJf').get();
  //   if (doc.exists) {
  //     doc.reference
  //         .update({'username': 'Jo', 'postCount': 12, 'isAdmin': false});
  //   }
  // }

  // Future<void> deleteUser() async {
  //   final doc = await userRef.doc('FXW7cCdxPuSr4exwJf').get();
  //   if (doc.exists) {
  //     doc.reference.delete();
  //   }
  // }

  // void getUsers() async {
  //   // final documents = await userRef.get();
  //   // users = documents.docs;
  //   final documents = await userRef.get();
  //   setState(() {
  //     users = documents.docs;
  //   });

  //   // userRef.get().then((QuerySnapshot snapshot) =>
  //   //     snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
  //   //       print(documentSnapshot.exists);
  //   //       print(documentSnapshot.id);
  //   //       print(documentSnapshot.data());
  //   //     }));

  //   // final documents =
  //   //     await userRef.orderBy('postCount', descending: true).get();
  //   // for (var doc in documents.docs) {
  //   //   print(doc.exists);
  //   //   print(doc.id);
  //   //   print(doc.data());
  //   // }
  // }

  // getUserById() async {
  //   String id = 'QUetj2dHXRuwSazzlp43';
  //   final doc = await userRef.doc(id).get();
  //   print(doc.exists);
  //   print(doc.id);
  //   print(doc.data());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isFeed: true),
      body: Container(),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: userRef.snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return circularLoading();
      //     }
      //     final children = snapshot.data!.docs
      //         .map((user) => Text(user['username']))
      //         .toList();
      //     return Container(
      //       child: ListView(
      //         children: children,
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
