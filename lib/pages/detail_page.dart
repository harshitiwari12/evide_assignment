import 'package:flutter/material.dart';
import '../models/stop.dart';

class DetailPage extends StatelessWidget {
  final Stop stop;

  const DetailPage({super.key, required this.stop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(stop.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${stop.description}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Latitude: ${stop.lat}"),
            Text("Longitude: ${stop.lng}"),
            const SizedBox(height: 20),
            Text("ETA: ${_calculateETA()} min", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  int _calculateETA() {
    // simple static formula
    return (stop.lat + stop.lng).toInt() % 20 + 5;
  }
}
