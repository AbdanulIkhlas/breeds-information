import 'package:flutter/material.dart';
import '../model/breeds_model.dart';

class BreedDetail extends StatelessWidget {
  final Breed breed;

  const BreedDetail({Key? key, required this.breed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(width: 16),
            Text(
              breed.name,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Color(0xFF1B1A55),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF1B1A55),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    breed.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    breed.description,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 16.0),
                  _buildDetailItem("Type", breed.type),
                  _buildDetailItem(
                      "Hypoallergenic", breed.hypoallergenic ? "Yes" : "No"),
                  _buildDetailItem(
                      "Life Span", "${breed.life.min} - ${breed.life.max} years"),
                  _buildDetailItem("Male Weight",
                      "${breed.maleWeight.min} - ${breed.maleWeight.max} kg"),
                  _buildDetailItem("Female Weight",
                      "${breed.femaleWeight.min} - ${breed.femaleWeight.max} kg"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String? value) {
    return value != null && value.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
