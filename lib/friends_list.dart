import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<String> _friends = List.empty();

  void initState() {
    super.initState();
    fetchUserFriends();
  }

  Future<void> fetchUserFriends() async {
    User? _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_user.uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        _friends = (data?['friends'] as List<dynamic>?)
                ?.map((friend) => friend.toString())
                .toList() ??
            List.empty();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF15131C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: (Text(
          "Friends List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        )),
      ),
      backgroundColor: Color(0xFF15131C),
      body: ListView.builder(
          itemCount: _friends.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                      color: Color(0xFF21222D),
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          child: Icon(
                            FontAwesomeIcons.userTie,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _friends[index],
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
