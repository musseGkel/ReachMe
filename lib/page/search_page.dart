import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/home_page.dart';
import 'package:reach_me/models/u/user.dart';
import 'package:reach_me/widgets/loadng.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  //late Future<QuerySnapshot> searchResults;
  Future<QuerySnapshot>? searchResults;
  // bool isIntialized = false;

  handleSearch(String query) {
    Future<QuerySnapshot> users = userRef
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();
    setState(() {
      searchResults = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
      appBar: buildSearch(context),
      body: searchResults == null ? buildNoContent() : buildResults(),
    );
  }

  buildResults() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResults,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return circularLoading();
        }
        List<UserResult> userResults = [];
        snapshot.data.docs.forEach((doc) {
          User user = User.deSerialize(doc);
          // textResults.add(Text(user.displayName));
          userResults.add(UserResult(user: user));
        });
        return ListView(
          children: userResults,
        );
      },
    );
  }

  Center buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          SvgPicture.asset(
            'assets/images/search.svg',
            height: orientation == Orientation.portrait ? 280 : 160,
          ),
          Text(
            'search users',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: orientation == Orientation.portrait ? 55 : 35,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }

  AppBar buildSearch(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_box,
            color: Theme.of(context).primaryColor,
          ),
          hintText: 'Search for a user',
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller.clear();
            },
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;
  UserResult({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: [
          GestureDetector(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                '${user.displayName}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${user.username}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white38,
          )
        ],
      ),
    );
  }
}
