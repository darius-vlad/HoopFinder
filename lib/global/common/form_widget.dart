import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoopfinder/settings_page.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  late TextEditingController controller;
  String text = "";

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF15131C),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF15131C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(
                height: 180,
              ),
              const Text(
                "Please insert new username",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF21222D),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: controller,
                    onSubmitted: (String value) {
                      _submitText();
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: _submitText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21222D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitText() {
    setState(() {
      text = controller.text;
    });
    _updateUsername(text);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  Future<void> _updateUsername(String text) async {
    User? _user = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance.collection('users');
    if (_user != null)
      await collection.doc(_user.uid).update({'username': text});
  }
}
