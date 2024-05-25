import 'package:flutter/material.dart';
import '../model/model_lookup.dart'; 
import '../services/api_data_source.dart';
import 'package:url_launcher/url_launcher.dart';

class LookupPage extends StatefulWidget {
  final String mealId; // Menerima id makanan sebagai argument

  const LookupPage({Key? key, required this.mealId}) : super(key: key);

  @override
  _LookupPageState createState() => _LookupPageState();
}

class _LookupPageState extends State<LookupPage> {
  late Future<Meals> _futureMeal;

  @override
  void initState() {
    super.initState();
    _futureMeal = _loadMeal(widget.mealId);
  }

  Future<Meals> _loadMeal(String id) async {
    try {
      final response = await ApiDataSource().loadLookup(id);
      final mealData = DetailMeals.fromJson(response);
      return mealData.meals![0]; // Mengembalikan data makanan pertama dari respons
    } catch (e) {
      throw Exception('Failed to load meal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Detail"),
      ),
      body: FutureBuilder<Meals>(
        future: _futureMeal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _buildMealDetails(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildMealDetails(Meals meal) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.strMeal ?? "",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            "Category: ${meal.strCategory ?? ""}",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          meal.strMealThumb != null
              ? Image.network(
                  meal.strMealThumb!,
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  fit: BoxFit.cover,
                )
              : SizedBox.shrink(),
          SizedBox(height: 16.0),
          Text(
            "Instructions:",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            meal.strInstructions ?? "",
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _launchYoutubeUrl(meal.strYoutube);
            },
            child: Text("Watch on Youtube"),
          ),
          SizedBox(height: 32.0),
        ],
      ),
    );
  }

  void _launchYoutubeUrl(String? youtubeUrl) async {
    if (youtubeUrl != null && await canLaunch(youtubeUrl)) {
      await launch(youtubeUrl);
    } else {
      throw 'Could not launch $youtubeUrl';
    }
  }
}
