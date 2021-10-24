import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/home_page.dart';
import 'package:reach_me/models/u/user.dart';
import 'package:reach_me/page/search_page.dart';
import 'package:reach_me/widgets/header.dart';
import 'package:reach_me/widgets/loadng.dart';
import 'package:reach_me/widgets/post.dart';

class TimelinePage extends StatefulWidget {
  final User currentUser;
  const TimelinePage({required this.currentUser});
  // const TimelinePage({Key? key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
  }

  List<Post>? posts;
  List<String> followingList = [];

  getFollowing() async {
    QuerySnapshot followingSnapshot = await followingRef
        .doc(widget.currentUser.id)
        .collection('userFollowing')
        .get();

    followingSnapshot.docs.forEach((doc) {
      followingList.add(doc.id);
    });
  }

  Future getTimeline() async {
    List<Post> userPosts = [];
    //getting list of users which the user is following
    QuerySnapshot followingSnapshot = await followingRef
        .doc(widget.currentUser.id)
        .collection('userFollowing')
        .get();

    followingSnapshot.docs.forEach((doc) async {
      final String userId = doc.id;
      //for each user get their post
      QuerySnapshot postSnapshot = await postsRef
          .doc(userId)
          .collection('userPosts')
          .limit(5)
          .orderBy('timestamp', descending: true)
          .get();
      postSnapshot.docs.forEach((postDoc) {
        userPosts.add(Post.deSerialze(postDoc));
      });
      setState(() {
        posts = userPosts;
      });
    });

    // userPosts.forEach((element) {
    //   if(element.)
    //  })
  }

  buildUsersListToFollow() {
    return StreamBuilder(
      stream:
          userRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return circularLoading();
        List<UserResult> userResults = [];
        snapshot.data.docs.forEach((doc) {
          User user = User.deSerialize(doc);
          //excluding current user from the list

          if (widget.currentUser.id == user.id)
            return;
          //if already following
          else if (followingList.contains(user.id))
            return;
          else
            userResults.add(UserResult(user: user));
        });
        if (userResults.isEmpty) return Text('no data in this app');
        return ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Users you may know',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(children: userResults)
          ],
          // children: userResults,
        );
      },
    );
  }

  buildTimeline() {
    if (posts == null) {
      return circularLoading();
    } else if (posts!.isEmpty) {
      return buildUsersListToFollow();
    } else {
      return ListView(
        children: posts!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, titile: 'Timeline'),
        body: RefreshIndicator(
          onRefresh: getTimeline,
          child: buildTimeline(),
        ));
  }
}
