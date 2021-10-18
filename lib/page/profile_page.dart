import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/home_page.dart';
import 'package:reach_me/models/u/user.dart';
import 'package:reach_me/page/edit_profile_page.dart';
import 'package:reach_me/widgets/header.dart';
import 'package:reach_me/widgets/loadng.dart';
import 'package:reach_me/widgets/post.dart';
import 'package:reach_me/widgets/post_tile.dart';

class ProfilePage extends StatefulWidget {
  final String profileId;
  const ProfilePage({Key? key, required this.profileId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum Orientation { grid, list }

class _ProfilePageState extends State<ProfilePage> {
  String currentUserId = currentUser.id;
  int postCount = 0;
  bool isLoading = false;
  List<Post> posts = [];
  Orientation postOrientation = Orientation.grid;

  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.deSerialze(doc)).toList();
    });
  }

  buildCount(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  buildButton({required String text, final function}) {
    return TextButton(
      onPressed: function,
      child: Container(
        alignment: Alignment.center,
        width: 240,
        height: 28,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.blue,
            )),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfile(
            currentUserId: currentUserId,
          ),
        ));
  }

  buildHeaderButton() {
    if (currentUser.id == widget.profileId) {
      return buildButton(
        text: 'Edit Profile',
        function: editProfile,
      );
    } else
      Container();
  }

  buildHeaderProfile() {
    return FutureBuilder(
      future: userRef.doc(widget.profileId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return circularLoading();
        }
        User user = User.deSerialize(snapshot.data);
        return Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCount('posts', postCount),
                            buildCount('followers', 2),
                            buildCount('following', 2),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildHeaderButton()
                      ],
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 4),
                alignment: Alignment.centerLeft,
                child: Text(user.username),
              ),
              Container(
                padding: EdgeInsets.only(top: 4),
                alignment: Alignment.centerLeft,
                child: Text(user.displayName),
              ),
              Container(
                padding: EdgeInsets.only(top: 2),
                alignment: Alignment.centerLeft,
                child: Text(user.bio),
              )
            ],
          ),
        );
      },
    );
  }

  buildProfilePosts() {
    if (isLoading)
      return circularLoading();
    else if (posts.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/no_content.svg',
              height: 240,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 50,
              width: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
              ),
              child: Text(
                'no posts',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (postOrientation == Orientation.grid) {
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(
          child: PostTile(post),
        ));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (postOrientation == Orientation.list) {
      return Column(
        children: posts,
      );
    }
  }

  setPostOrientation(postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  buildSwitchOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () => setPostOrientation(Orientation.grid),
          icon: Icon(Icons.grid_on),
          color: postOrientation == Orientation.grid
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setPostOrientation(Orientation.list),
          icon: Icon(Icons.list),
          color: postOrientation == Orientation.list
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, titile: 'Profile'),
        body: ListView(
          children: [
            buildHeaderProfile(),
            Divider(),
            buildSwitchOrientation(),
            Divider(),
            buildProfilePosts(),
          ],
        ));
  }
}
