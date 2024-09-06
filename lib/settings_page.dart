import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hoopfinder/authentication/login.dart';
import 'package:hoopfinder/global/common/form_widget.dart';
import 'package:hoopfinder/global/common/toast.dart';
import 'package:hoopfinder/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _name = "";
  String _email = "";

  void initState() {
    super.initState();
    _fetcUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF15131C),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      backgroundColor: const Color(0xFF15131C),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: const Color(0xFF21222D)),
              width: double.infinity,
              height: 150,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Icon(FontAwesomeIcons.userTie),
                      radius: 38,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50, left: 15),
                      child: Column(
                        children: [
                          Text(
                            _name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _email,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF21222D)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FormWidget()));
                      },
                      child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.lightBlue.shade600,
                                child: const Center(
                                  child: Icon(
                                    FontAwesomeIcons.solidAddressCard,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                "Edit profile",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(
                                width: 180,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                              )
                            ],
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF21222D)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.amber.shade300,
                                  child: const Icon(
                                    FontAwesomeIcons.exclamation,
                                    color: Colors.white,
                                  )),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                "Suggest a court",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(
                                width: 138,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                              )
                            ],
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF21222D)),
                      onPressed: () {
                        _signOut(context);
                      },
                      child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.deepOrange.shade700,
                                child: const Icon(
                                  FontAwesomeIcons.rightFromBracket,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Text(
                                "Log Out",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(
                                width: 203,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                              )
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
    showToast(message: "Successfully Signed Out");
  }

  Future<void> _fetcUserData() async {
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
          _name = data?['username'] ?? 'username';
          _email = data?['email'] ?? 'email';
        });
      }
    }
  }
}
