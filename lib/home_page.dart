import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reach_me/page/activity_log_page.dart';
import 'package:reach_me/page/create_account_page.dart';
import 'package:reach_me/page/profile_page.dart';
import 'package:reach_me/page/search_page.dart';
import 'package:reach_me/page/send_page.dart';
import 'models/u/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final googleSignIn = GoogleSignIn();
final userRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final DateTime timestamp = DateTime.now();
late User currentUser;
final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged
        .listen((account) => handleAccount(account), onError: (err) {
      print(err);
    });
    googleSignIn
        .signInSilently()
        .then((account) => handleAccount(account))
        .catchError((err) {
      print(err);
    });
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.easeOutQuart);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  handleAccount(account) async {
    if (account != null) {
      await createAccount();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createAccount() async {
    final user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.doc(user!.id).get();

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      print('*************************************' +
          '${user.id}' +
          '\n'
              '$username' +
          '\n'
              '${user.email}' +
          '\n'
              '${user.displayName}' +
          '\n'
              '${user.photoUrl}' +
          '\n'
              '$timestamp' +
          '\n'
              '*************************************');
      userRef.doc(user.id).set(
        {
          'id': user.id,
          'username': username,
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoUrl,
          'timestamp': timestamp,
          'bio': ''
        },
      );
      doc = await userRef.doc(user.id).get();
    }
    currentUser = User.deSerialize(doc);
    print('*************************************');
    print(currentUser);
    print(currentUser.email);
    print('*************************************');
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    //googleSignIn.disconnect();
    googleSignIn.signOut();
    print('logout');
  }

  Scaffold buildAuth() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
        children: [
          ElevatedButton(
            onPressed: () {
              logout();
            },
            child: Text('Logout'),
          ),
          // FeedPage(),
          ActivityLog(),
          SendPage(currentUser: currentUser),
          SearchPage(),
          ProfilePage(profileId: currentUser.id)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: pageIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            label: 'Activity',
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            label: 'Send',
            icon: Icon(Icons.upload),
          ),
          BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(
                Icons.search,
              )),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_circle),
          )
        ],
      ),
    );
  }

  Scaffold buildUnAuth() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ReachMe',
              style: TextStyle(
                color: Colors.black,
                fontSize: 90,
                fontFamily: 'Signatra',
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                height: 60,
                width: 260,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth == true ? buildAuth() : buildUnAuth();
  }
}
