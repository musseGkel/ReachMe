import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/home_page.dart';
import 'package:reach_me/page/post_page.dart';
import 'package:reach_me/page/profile_page.dart';
import 'package:reach_me/widgets/header.dart';
import 'package:reach_me/widgets/loadng.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotficationPage extends StatefulWidget {
  const NotficationPage({Key? key}) : super(key: key);

  @override
  _NotficationPageState createState() => _NotficationPageState();
}

class _NotficationPageState extends State<NotficationPage> {
  getNotfications() async {
    List<NotificationItem> notificationItems = [];
    QuerySnapshot snapshot = await notificationRef
        .doc(currentUser.id)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    snapshot.docs.forEach((doc) {
      notificationItems.add(NotificationItem.deserialize(doc));
      // print('Notification : ${doc.data()}');
    });
    return notificationItems; //snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titile: 'Notifications'),
      body: Container(
        child: FutureBuilder(
          future: getNotfications(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return circularLoading();
            return ListView(
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }
}

Widget? mediaPreview;
String? notificationText;

class NotificationItem extends StatelessWidget {
  final String type;
  final String message;
  final String username;
  final String userId;
  final String profilePic;
  final String postId;
  final String mediaLink;
  final Timestamp timestamp;
  NotificationItem(
      {required this.type,
      required this.message,
      required this.username,
      required this.userId,
      required this.profilePic,
      required this.postId,
      required this.mediaLink,
      required this.timestamp});

  factory NotificationItem.deserialize(DocumentSnapshot doc) {
    return NotificationItem(
      type: doc['type'],
      message: doc['message'],
      username: doc['username'],
      userId: doc['userId'],
      profilePic: doc['profilePic'],
      postId: doc['postId'],
      mediaLink: doc['mediaLink'],
      timestamp: doc['timestamp'],
    );
  }
  configureMediaPreview(BuildContext context) {
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PostPage(userId: userId, postId: postId)));
        },
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(mediaLink))),
            ),
          ),
        ),
      );
    } else
      mediaPreview = Text('');

    if (type == 'like')
      notificationText = 'liked your post';
    else if (type == 'comment')
      notificationText = 'replied: \'$message\'';
    else if (type == 'follow')
      notificationText = 'is following you';
    else
      notificationText = 'error';
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Container(
      child: ListTile(
        title: GestureDetector(
          onTap: () => showProfile(context, profileId: userId),
          child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                  children: [
                    TextSpan(
                        text: username + ' ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: notificationText)
                  ])),
        ),
        subtitle: Text(timeago.format(timestamp.toDate())),
        trailing: mediaPreview,
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(profilePic),
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {required String profileId}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage(profileId: profileId)));
}
