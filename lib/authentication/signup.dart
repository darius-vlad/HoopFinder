import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoopfinder/authentication/login.dart';
import 'package:hoopfinder/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:hoopfinder/global/common/form_container_widget.dart';
import 'package:hoopfinder/global/common/toast.dart';
import 'package:hoopfinder/main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  bool isSigningUp = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            },
          ),
          title: Text(
            "Sign Up",
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          backgroundColor: Colors.grey[800],
        ),
        backgroundColor: Colors.grey[800],
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Sign Up",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  _signUp();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isSigningUp
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Sign up",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.deepOrange.shade400,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ]),
          ),
        ));
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    List<String> friends = List.empty();

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': username,
        'email': email,
        'isPlaying': false,
        'matches_played': 0,
        'points': 0,
        'assists': 0,
        'steals': 0,
        'blocks': 0,
        'rebounds': 0,
        '3pt': 0,
        'wins': 0,
        'losses': 0,
        'friends': friends
      });
      user.updateDisplayName(username);

      setState(() {
        isSigningUp = false;
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));

      showToast(message: "User successfully created");
    } else {
      setState(() {
        isSigningUp = false;
      });
      showToast(message: "Some error occurred");
    }
  }
}
