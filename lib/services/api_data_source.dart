import 'base_network.dart';
import '../model/breeds_model.dart';

class ApiDataSource {
  static final ApiDataSource _instance = ApiDataSource._internal();

  factory ApiDataSource() {
    return _instance;
  }

  ApiDataSource._internal();

  Future<Map<String, dynamic>> loadCategory() async {
    return await BaseNetwork.get("categories.php");
  }

  Future<Map<String, dynamic>> loadFilter(String id) async {
    return await BaseNetwork.get("filter.php?c=$id");
  }

  Future<Map<String, dynamic>> loadLookup(String id) async {
    return await BaseNetwork.get("lookup.php?i=$id");
  }

  Future<List<Breed>> loadBreeds() async {
    final response = await BaseNetwork.get("breeds");
    if (response.containsKey('data')) {
      final List<dynamic> breedsJson = response['data'];
      return breedsJson.map((json) => Breed.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load breeds");
    }
  }
}
