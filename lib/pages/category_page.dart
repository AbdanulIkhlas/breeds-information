import 'package:flutter/material.dart';
import '../services/api_data_source.dart';
import '../model/categories.dart';
import './filter_page.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Categories>? _categories;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await ApiDataSource().loadCategory();
      final categoryData = Category.fromJson(response);
      setState(() {
        _categories = categoryData.categories;
      });
    } catch (e) {
      // Handle error
      print('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: _categories != null
          ? ListView.builder(
              itemCount: _categories!.length,
              itemBuilder: (context, index) {
                final category = _categories![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterPage(category: category),
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
                              category.strCategoryThumb!,
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          flex: 3,
                          child: Text(
                            category.strCategory!,
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
