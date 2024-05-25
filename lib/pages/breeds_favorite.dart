import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/breeds_model.dart';
import '../breed_manager.dart';
import '../services/api_data_source.dart';
import './breeds_detail.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final BreedManager _breedManager = BreedManager();
  late SharedPreferences _prefs;
  List<Breed> _breeds = [];
  List<int> _favoriteIndices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _loadBreeds();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _breedManager.setPrefs(_prefs);
    setState(() {
      _favoriteIndices = _breedManager.favoriteIndices.toList();
    });
  }

  void _loadBreeds() async {
    try {
      List<Breed> breeds = await ApiDataSource().loadBreeds();
      setState(() {
        _breeds = breeds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load breeds'),
      ));
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      _breedManager.toggleFavorite(index);
      _favoriteIndices = _breedManager.favoriteIndices.toList();
    });

    String message = _breedManager.favoriteIndices.contains(index)
        ? 'Added to favorites'
        : 'Removed from favorites';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "Favorite Breeds",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF1B1A55),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _favoriteIndices.length,
              itemBuilder: (BuildContext context, int index) {
                final favoriteIndex = _favoriteIndices[index];
                final breed = _breeds[favoriteIndex];
                return Card(
                  color: Color(0xFF26257A),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    title: Text(
                      breed.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      breed.description,
                      style: TextStyle(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.star, color: Colors.amber),
                      onPressed: () => _toggleFavorite(favoriteIndex),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BreedDetail(breed: breed),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
