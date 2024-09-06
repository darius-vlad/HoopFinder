import 'package:flutter/material.dart';
import 'package:hoopfinder/activity_details.dart';
import 'package:hoopfinder/bar_graph.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

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
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Stats",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFF15131C),
      ),
      backgroundColor: Color(0xFF15131C),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ActivityDetailsCard(),
              SizedBox(
                height: 12,
              ),
              BarGraphCard(),
            ],
          ),
        ),
      ),
    );
  }
}
