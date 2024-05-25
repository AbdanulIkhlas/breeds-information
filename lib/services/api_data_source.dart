import 'base_network.dart';

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
}
