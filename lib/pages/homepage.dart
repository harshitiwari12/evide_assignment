import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/stop.dart';
import '../service/logal_storage.dart';
import 'detail_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Stop> stops = [];
  List<Stop> filtered = [];
  List<String> favStops = [];
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonStr = await rootBundle.loadString("assets/mock/stops.json");
    final List data = json.decode(jsonStr);
    stops = data.map((e) => Stop.fromJson(e)).toList();
    filtered = List.from(stops);
    favStops = await LocalStorage.getFavorites();
    setState(() {});
  }

  void _filter(String q) {
    if (q.isEmpty) {
      filtered = List.from(stops);
    } else {
      filtered = stops.where((s) =>
      s.name.toLowerCase().contains(q.toLowerCase()) ||
          s.description.toLowerCase().contains(q.toLowerCase())
      ).toList();
    }
    setState(() {});
  }

  void _toggleFav(String name) async {
    if (favStops.contains(name)) {
      favStops.remove(name);
    } else {
      favStops.add(name);
    }
    await LocalStorage.saveFavorites(favStops);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Bus Stops"),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Column(
        children: [
          // 🔍 Search box
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: "Search bus stops...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📋 Stops List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final stop = filtered[i];
                final isFav = favStops.contains(stop.name);

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: const Icon(Icons.directions_bus, color: Colors.blueAccent),
                    ),
                    title: Text(stop.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(stop.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: Icon(isFav ? Icons.star : Icons.star_border,
                          color: isFav ? Colors.orange : Colors.grey),
                      onPressed: () => _toggleFav(stop.name),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailPage(stop: stop)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
