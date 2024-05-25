import 'package:http/http.dart' as http;
import 'dart:convert';

class BaseNetwork {
  static final String _baseUrl = "https://dogapi.dog/api/v2/";

  static Future<Map<String, dynamic>> get(String partUrl) async {
    final String fullUrl = _buildFullUrl(partUrl);
    _logDebug("fullUrl: $fullUrl");

    final http.Response response = await http.get(Uri.parse(fullUrl));
    _logDebug("response: ${response.body}");

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> _processResponse(
      http.Response response) async {
    final String body = response.body;
    if (body.isNotEmpty) {
      final Map<String, dynamic> jsonBody = json.decode(body);
      return jsonBody;
    } else {
      _logDebug("processResponse error");
      return {"error": true};
    }
  }

  static String _buildFullUrl(String partUrl) {
    return "$_baseUrl$partUrl";
  }

  static void _logDebug(String value) {
    print("[BASE_NETWORK] - $value");
  }
}
