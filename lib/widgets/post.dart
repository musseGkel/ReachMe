import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/home_page.dart';
import 'package:reach_me/models/u/user.dart';
import 'package:reach_me/page/comments_page.dart';
import 'package:reach_me/page/notfication_page.dart';
import 'package:reach_me/widgets/customized_widgets.dart';
import 'package:reach_me/widgets/loadng.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String mediaLink;
  final String description;
  final likes;
  Post({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.mediaLink,
    required this.description,
    this.likes,
  });
  factory Post.deSerialze(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaLink: doc['mediaLink'],
      likes: doc['likes'],
    );
  }

  getLikesCount(Map likes) {
    if (likes == null) return 0;
    int count = 0;
    likes.values.forEach((value) {
      if (value == true) count++;
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      ownerId: this.ownerId,
      username: this.username,
      location: this.location,
      mediaLink: this.mediaLink,
      description: this.description,
      likes: this.likes,
      likeCount: getLikesCount(this.likes));
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String mediaLink;
  final String description;
  final Map likes;
  int likeCount;

  bool? isliked;
  String currentUserId = currentUser.id;
  bool showHeartBeat = false;

  _PostState({
    required this.likeCount,
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.mediaLink,
    required this.description,
    required this.likes,
  });
  buildPostTop() {
    return FutureBuilder(
      future: userRef.doc(ownerId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return circularLoading();
        User user = User.deSerialize(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          ),
          title: GestureDetector(
              onTap: () => showProfile(context, profileId: ownerId),
              child: Text(user.username)),
          subtitle: Text(location),
          trailing: currentUserId == ownerId
              ? IconButton(
                  onPressed: () {
                    handleDeletePost(context);
                  },
                  icon: Icon(Icons.more_vert),
                )
              : Text(''),
        );
      },
    );
  }

  handleDeletePost(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'Delete this Post',
        ),
        children: [
          SimpleDialogOption(
            onPressed: () {
              deletePost();
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          )
        ],
      ),
    );
  }

  deletePost() async {
    //deleting the post from posts
    await postsRef
        .doc(ownerId)
        .collection('userPosts')
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //deleting the post's image from posts
    storageRef.child('post_$postId.jpg').delete();
    //deleting all the post's notifications
    QuerySnapshot querySnapshot = await notificationRef
        .doc(ownerId)
        .collection('notifications')
        .where('postId', isEqualTo: postId)
        .get();
    querySnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //deleting all the post's comments
    QuerySnapshot commentsQuerySnapshot =
        await commentRef.doc(postId).collection('comments').get();
    commentsQuerySnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleLike() {
    bool _isliked = likes[currentUserId] == true;
    if (_isliked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': false});
      removeLikeFromFeed();
      setState(() {
        likeCount--;
        isliked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isliked) //_isliked == false
    {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': true});
      addLikeToFeed();
      setState(() {
        isliked = true;
        likeCount++;
        likes[currentUserId] = true;
        showHeartBeat = true;
      });
      Timer(Duration(milliseconds: 600), () {
        setState(() {
          showHeartBeat = false;
        });
      });
    }
  }

  removeLikeFromFeed() {
    if (currentUserId != ownerId) {
      notificationRef
          .doc(ownerId)
          .collection('notifications')
          .doc(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  addLikeToFeed() {
    if (currentUserId != ownerId) {
      notificationRef.doc(ownerId).collection('notifications').doc(postId).set({
        'type': 'like',
        'username': currentUser.username,
        'userId': currentUser.id,
        'profilePic': currentUser.photoUrl,
        'postId': postId,
        'mediaLink': mediaLink,
        'timestamp': DateTime.now()
      });
    }
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: handleLike,
      child: Stack(
        alignment: Alignment.center,
        children: [
          cachedNetworkImage(mediaLink),
          showHeartBeat
              ? Animator<double>(
                  tween: Tween(begin: 0.8, end: 1.7),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  cycles: 0,
                  builder: (_, anim, __) => Transform.scale(
                      scale: anim.value,
                      child:
                          Icon(Icons.favorite, size: 100, color: Colors.pink)),
                )
              : Text(''),
        ],
      ),
    );
  }

  buildPostBottom() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: handleLike,
                child: Icon(
                  isliked == true ? Icons.favorite : Icons.favorite_border,
                  color: Colors.pink,
                  size: 28,
                )),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Comments(
                              postId: postId,
                              postMediaLink: mediaLink,
                              postOwnerId: ownerId,
                            )));
              },
              child: Icon(
                Icons.chat,
                color: Colors.blue,
                size: 28,
              ),
            )
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '$likeCount likes',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                '$username',
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(description),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isliked = likes[currentUserId] == true;
    return Column(
      children: [
        buildPostTop(),
        buildPostImage(),
        buildPostBottom(),
      ],
    );
  }
}
