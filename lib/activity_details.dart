import 'package:flutter/material.dart';
import 'package:hoopfinder/data/health_details.dart';
import 'package:hoopfinder/global/common/custom_card.dart';

class ActivityDetailsCard extends StatefulWidget {
  const ActivityDetailsCard({super.key});

  @override
  _ActivityDetailsCardState createState() => _ActivityDetailsCardState();
}

class _ActivityDetailsCardState extends State<ActivityDetailsCard> {
  late HealthDetails healthDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    healthDetails = HealthDetails();
    fetchStats();
  }

  Future<void> fetchStats() async {
    await healthDetails.fetchUserStats();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      itemCount: healthDetails.healthData.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12.0),
      itemBuilder: (context, index) => CustomCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                healthDetails.healthData[index].title,
                style: const TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              healthDetails.healthData[index].value,
              style: const TextStyle(
                fontSize: 13,
                decoration: TextDecoration.none,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
