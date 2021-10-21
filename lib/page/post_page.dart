import 'package:flutter/material.dart';
import 'package:reach_me/home_page.dart';
import 'package:reach_me/widgets/header.dart';
import 'package:reach_me/widgets/loadng.dart';
import 'package:reach_me/widgets/post.dart';

class PostPage extends StatelessWidget {
  final String userId;
  final String postId;
  PostPage({required this.userId, required this.postId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef.doc(userId).collection('userPosts').doc(postId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return circularLoading();
        Post post = Post.deSerialze(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: header(context, titile: post.description),
            body: ListView(
              children: [post],
            ),
          ),
        );
      },
    );
  }
}
