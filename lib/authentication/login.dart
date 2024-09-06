import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoopfinder/authentication/signup.dart';
import 'package:hoopfinder/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:hoopfinder/global/common/form_container_widget.dart';
import 'package:hoopfinder/global/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoopfinder/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSigningIn = false;
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
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
            "Login",
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
              Text("Login",
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
                onTap: _signIn,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: isSigningIn
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Login",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
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
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                          (route) => false);
                    },
                    child: Text(
                      "Sign Up",
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

  void _signIn() async {
    setState(() {
      isSigningIn = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      isSigningIn = false;
    });

    if (user != null) {
      showToast(message: "User successfully signed in");

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        userDoc.get('username');
        userDoc.get('email');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        showToast(message: "User data not found");
      }
    } else {
      showToast(message: "Some error occurred");
    }
  }
}
