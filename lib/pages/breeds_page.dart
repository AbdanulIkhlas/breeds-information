import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/breeds_model.dart';
import '../services/api_data_source.dart';
import '../breed_manager.dart';
import './breeds_detail.dart'; 
import '../main.dart';

class BreedPage extends StatefulWidget {
  const BreedPage({Key? key}) : super(key: key);

  @override
  _BreedPageState createState() => _BreedPageState();
}

class _BreedPageState extends State<BreedPage> {
  final BreedManager _breedManager = BreedManager();
  late SharedPreferences _prefs;
  List<Breed> _breeds = [];
  bool _isLoading = true;
  late SharedPreferences logindata;
  late String username = "";

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _loadBreeds();
    initial();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _breedManager.setPrefs(_prefs);
    setState(() {
      _isLoading = false;
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

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  void logout() {
    logindata.setBool('login', true);
    logindata.remove('username');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "Breeds List",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF1B1A55),
        actions: [
          TextButton(
            onPressed: () {
              logout();
            },
            child: Text(
              "LOGOUT",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(Icons.logout_sharp, color: Colors.white))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _breeds.length,
              itemBuilder: (BuildContext context, int index) {
                final breed = _breeds[index];
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
                      icon: _breedManager.favoriteIndices.contains(index)
                          ? Icon(Icons.star, color: Colors.amber)
                          : Icon(Icons.star_border, color: Colors.white),
                      onPressed: () => _toggleFavorite(index),
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
