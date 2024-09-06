import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hoopfinder/authentication/login.dart';
import 'package:hoopfinder/authentication/signup.dart';
import 'package:hoopfinder/firebase_options.dart';
import 'package:hoopfinder/friends_list.dart';
import 'package:hoopfinder/main_page.dart';
import 'package:hoopfinder/map_page.dart';
import 'package:hoopfinder/settings_page.dart';
import 'package:hoopfinder/stats_page.dart';

//margins of 16px to change
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(
    home: MainPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;
  String _displayName = "Hooper";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_user.uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        setState(() {
          _displayName = data?['username'] ?? 'Hooper';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Text(
                    'Hello $_displayName!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700),
                  ),
                SizedBox(
                  width: 6,
                ),
                Icon(
                  FontAwesomeIcons.basketball,
                  color: Colors.orangeAccent,
                )
              ],
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              "Are you ready to hoop?",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )
          ],
        ),
        backgroundColor: Color(0xFF15131C),
      ),
      backgroundColor: Color(0xFF15131C),
      body: Stack(
        children: [
          //container 1
          Positioned(
            left: 16,
            top: 90,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapPage(
                            playerName: _displayName!,
                          )),
                );
              },
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Color(0xFF21222D),
                  // image: const DecorationImage(
                  //     image: AssetImage('assets/images/find_game.png'),
                  //     fit: BoxFit.cover),
                  //color: Color.fromARGB(255, 49, 54, 56),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade600,
                  //     blurRadius: 4,
                  //     offset: Offset(0, 4),
                  //     spreadRadius: 1,
                  //   ),
                  // ],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 42,
                      left: 12,
                      child: Text(
                        "Find a",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Text(
                        "Court",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 90),
                      child: Icon(
                        FontAwesomeIcons.locationDot,
                        color: Colors.orange,
                        size: 64,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          //container 2
          Positioned(
            right: 16,
            top: 90,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatsPage()),
                );
              },
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Color(0xFF21222D),
                  // image: const DecorationImage(
                  //     image: AssetImage('assets/images/find_game.png'),
                  //     fit: BoxFit.cover),
                  //color: Color.fromARGB(255, 49, 54, 56),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade600,
                  //     blurRadius: 4,
                  //     offset: Offset(0, 4),
                  //     spreadRadius: 1,
                  //   ),
                  // ],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 42,
                      left: 12,
                      child: Text(
                        "See your",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Text(
                        "Stats",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 90),
                      child: Icon(
                        FontAwesomeIcons.chartPie,
                        color: Colors.purple,
                        size: 64,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          //container 3
          Positioned(
            left: 16,
            top: 290,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendsPage()),
                );
              },
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Color(0xFF21222D),
                  // image: const DecorationImage(
                  //     image: AssetImage('assets/images/find_game.png'),
                  //     fit: BoxFit.cover),
                  //color: Color.fromARGB(255, 49, 54, 56),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade600,
                  //     blurRadius: 4,
                  //     offset: Offset(0, 4),
                  //     spreadRadius: 1,
                  //   ),
                  // ],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 42,
                      left: 12,
                      child: Text(
                        "Chat with",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Text(
                        "Friends",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 90),
                      child: Icon(
                        FontAwesomeIcons.userGroup,
                        color: Colors.blue,
                        size: 64,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          //container 4
          Positioned(
            right: 16,
            top: 290,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Color(0xFF21222D),
                  // image: const DecorationImage(
                  //     image: AssetImage('assets/images/find_game.png'),
                  //     fit: BoxFit.cover),
                  //color: Color.fromARGB(255, 49, 54, 56),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade600,
                  //     blurRadius: 4,
                  //     offset: Offset(0, 4),
                  //     spreadRadius: 1,
                  //   ),
                  // ],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 42,
                      left: 12,
                      child: Text(
                        "Go to",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 90),
                      child: Icon(
                        FontAwesomeIcons.gear,
                        color: Colors.red,
                        size: 64,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 558,
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xFF21222D),
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's drill:",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                      Text(
                        "Lower Body Plyometric (3 sets x 10-12 jumps):",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "Box Jumps",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "Depth Jumps",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "Lateral Bounds",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
