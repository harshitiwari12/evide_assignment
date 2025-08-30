import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/stop.dart';
import '../service/logal_storage.dart';
import '../widgets/stop_tile.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Stop> _stops = [];
  List<String> _favorites = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadStops();
    _loadFavorites();
  }

  Future<void> _loadStops() async {
    final data = await rootBundle.loadString("assets/mock/stops.json");
    final jsonResult = json.decode(data) as List;
    setState(() {
      _stops = jsonResult.map((e) => Stop.fromJson(e)).toList();
    });
  }

  Future<void> _loadFavorites() async {
    final favs = await LocalStorage.getFavorites();
    setState(() {
      _favorites = favs;
    });
  }

  void _toggleFavorite(String name) {
    setState(() {
      if (_favorites.contains(name)) {
        _favorites.remove(name);
      } else {
        _favorites.add(name);
      }
    });
    LocalStorage.saveFavorites(_favorites);
  }

  @override
  Widget build(BuildContext context) {
    final filteredStops = _stops
        .where((s) =>
        s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Stops"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStops.length,
              itemBuilder: (context, index) {
                final stop = filteredStops[index];
                final isFav = _favorites.contains(stop.name);
                return StopTile(
                  stop: stop,
                  isFavorite: isFav,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(stop: stop),
                      ),
                    );
                  },
                  onFavoriteToggle: () => _toggleFavorite(stop.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
