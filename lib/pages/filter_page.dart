import 'package:flutter/material.dart';
import '../pages/lookup_page.dart';
import '../model/categories.dart';
import '../model/model_filter.dart'; // Import model yang diperlukan
import '../services/api_data_source.dart';

class FilterPage extends StatefulWidget {
  final Categories category;

  FilterPage({required this.category});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<FilteredMeals>? _meals; // Ubah tipe data menjadi FilteredMeals

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      final response =
          await ApiDataSource().loadFilter(widget.category.strCategory!);
      final filterData = CategoryFilter.fromJson(response);
      setState(() {
        _meals = filterData.meals;
      });
    } catch (e) {
      // Handle error
      print('Error loading meals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.strCategory!),
      ),
      body: _meals != null
          ? ListView.builder(
              itemCount: _meals!.length,
              itemBuilder: (context, index) {
                final meal = _meals![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LookupPage(mealId: meal.idMeal!),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              meal.strMealThumb!,
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          flex: 3,
                          child: Text(
                            meal.strMeal!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
