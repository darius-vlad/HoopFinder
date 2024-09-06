import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoopfinder/model/bar_graph_model.dart';
import 'package:hoopfinder/model/graph_model.dart';

class BarGraphData {
  double _points = 0;
  double _assists = 0;
  double _blocks = 0;
  double _steals = 0;
  double _rebounds = 0;
  double _3pt = 0;

  Future<void> fetchUserStats() async {
    User? _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_user.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        _3pt = data?['3pt'].toDouble() ?? 0;
        _assists = data?['assists'].toDouble() ?? 0;
        _blocks = data?['blocks'].toDouble() ?? 0;
        _points = data?['points'].toDouble() ?? 0;
        _rebounds = data?['rebounds'].toDouble() ?? 0;
        _steals = data?['steals'].toDouble() ?? 0;
        updateGraphData();
      }
    }
  }

  List<BarGraphModel> data = [];
  final label = ['Points', 'Assists', 'Blocks', 'Steals', 'Rebounds', '3PT'];

  void updateGraphData() {
    data = [
      BarGraphModel(label: "Activity Level", color: Color(0xFFFEB95A), graph: [
        GraphModel(x: 0, y: _points),
        GraphModel(x: 1, y: _assists),
        GraphModel(x: 2, y: _blocks),
        GraphModel(x: 3, y: _steals),
        GraphModel(x: 4, y: _rebounds),
        GraphModel(x: 5, y: _3pt),
      ]),
    ];
  }
}
