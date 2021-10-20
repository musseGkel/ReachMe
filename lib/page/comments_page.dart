import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/home_page.dart';
import 'package:reach_me/widgets/header.dart';
import 'package:reach_me/widgets/loadng.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaLink;
  const Comments(
      {required this.postId,
      required this.postOwnerId,
      required this.postMediaLink});

  @override
  _CommentsState createState() => _CommentsState(
      postId: this.postId,
      postOwnerId: this.postOwnerId,
      postMediaLink: this.postMediaLink);
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaLink;
  _CommentsState(
      {required this.postId,
      required this.postOwnerId,
      required this.postMediaLink});

  addComment() async {
    await commentRef.doc(postId).collection('comments').add({
      'username': currentUser.username,
      'userId': currentUser.id,
      'message': commentController.text,
      'timestamp': DateTime.now(),
      'profilePic': currentUser.photoUrl,
    });
    addCommentToFeed();
    commentController.clear();
  }

  addCommentToFeed() {
    if (currentUser.id == postOwnerId) {
      notificationRef.doc(postOwnerId).collection('notifications').add({
        'type': 'comment',
        'message': commentController.text,
        'username': currentUser.username,
        'userId': currentUser.id,
        'profilePic': currentUser.photoUrl,
        'postId': postId,
        'mediaLink': postMediaLink,
        'timestamp': DateTime.now()
      });
    }
  }

  displayComments() {
    return StreamBuilder(
      stream: commentRef
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return circularLoading();
        List<Comment> comments = [];
        snapshot.data!.docs.forEach((doc) {
          comments.add(Comment.deSerialize(doc));
        });
        return ListView(children: comments);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        titile: 'Comments',
      ),
      body: Column(
        children: [
          Expanded(child: displayComments()),
          Divider(),
          ListTile(
            title: TextFormField(
                controller: commentController,
                decoration: InputDecoration(
                  label: Text('write a comment...'),
                )),
            trailing: OutlinedButton(
              onPressed: addComment,
              child: Text('Comment'),
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String message;
  final String profilePic;
  final Timestamp timestamp;
  Comment(
      {required this.username,
      required this.userId,
      required this.message,
      required this.profilePic,
      required this.timestamp});
  factory Comment.deSerialize(DocumentSnapshot doc) {
    return Comment(
        username: doc['username'],
        userId: doc['userId'],
        message: doc['message'],
        profilePic: doc['profilePic'],
        timestamp: doc['timestamp']);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Text(message),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(profilePic),
            ),
            subtitle: Text(timeago.format(timestamp.toDate()))),
        Divider()
      ],
    );
  }
}
