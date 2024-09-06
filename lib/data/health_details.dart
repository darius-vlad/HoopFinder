import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoopfinder/model/health_model.dart';

class HealthDetails {
  String _3pt = '0';

  String _assists = '0';

  String _blocks = '0';

  String _losses = '0';

  String _matchesPlayed = '0';

  String _points = '0';

  String _rebounds = '0';

  String _steals = '0';

  String _wins = '0';

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
        _3pt = data?['3pt'].toString() ?? '0';
        _assists = data?['assists'].toString() ?? '0';
        _blocks = data?['blocks'].toString() ?? '0';
        _losses = data?['losses'].toString() ?? '0';
        _matchesPlayed = data?['matches_played'].toString() ?? '0';
        _points = data?['points'].toString() ?? '0';
        _rebounds = data?['rebounds'].toString() ?? '0';
        _steals = data?['steals'].toString() ?? '0';
        _wins = data?['wins'].toString() ?? '0';
        updateHealthData();
      }
    }
  }

  List<HealthModel> healthData = [];

  void updateHealthData() {
    healthData = [
      HealthModel(value: _matchesPlayed, title: "Matches Played:"),
      HealthModel(value: _points, title: "Points Scored:"),
      HealthModel(value: '$_wins/$_losses', title: "Win/Loss:"),
      HealthModel(value: _assists, title: "Assists:"),
      HealthModel(value: _3pt, title: "3PT:"),
      HealthModel(value: _steals, title: "Steals:"),
      HealthModel(value: _blocks, title: "Blocks:"),
      HealthModel(value: _rebounds, title: "Rebounds:"),
    ];
  }
}
