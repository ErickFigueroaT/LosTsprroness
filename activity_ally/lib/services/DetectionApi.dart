import 'package:http/http.dart' as http;
import 'dart:convert';

class DetectionApi{

  static final DetectionApi instance = DetectionApi._init();

  DetectionApi._init();

  Future<void> performDetection(String url) async {
    try {
      final String apiUrl = 'https://api.edenai.run/v2/image/object_detection';
      final String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNzljYjcwN2UtMzQ3Yi00YWI3LWE4ODAtNTRiYTUzMWU0OTMxIiwidHlwZSI6ImFwaV90b2tlbiJ9.hbnmZUEfX3840fheYRrrJ9MeYWY_Tvpnhzk20rOepKM';

      final Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};

      final Map<String, dynamic> jsonPayload = {
        'show_original_response': false,
        'fallback_providers': '',
        'providers': 'google, amazon',
        'file_url': '$url',
      };

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(jsonPayload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        print(result['google']['items']);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<List<Map<String, dynamic>>?> detect(String filePath) async {
    try {
      final headers = {"Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNzljYjcwN2UtMzQ3Yi00YWI3LWE4ODAtNTRiYTUzMWU0OTMxIiwidHlwZSI6ImFwaV90b2tlbiJ9.hbnmZUEfX3840fheYRrrJ9MeYWY_Tvpnhzk20rOepKM"};
      final url = "https://api.edenai.run/v2/image/object_detection";
      final data = {
        "show_original_response": false.toString(),
        "fallback_providers": "",
        "providers": "google,amazon"
      };

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..fields.addAll(data)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          '$filePath',
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final result = jsonDecode(await response.stream.bytesToString());
        //print(result);
        //print('\n===============\n');
        //print(result['amazon']['items']);
        return (result['amazon']['items'] as List).cast<Map<String, dynamic>>();
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  void decode(List<Map<String, dynamic>> response ){
    //List<Map<String, dynamic>> response = (jsonDecode(jsonResponse) as List).cast<Map<String, dynamic>>();
    Map<String, String> result = processResponse(response);

    // Print the result
    result.forEach((box, label) {
      print('Box: $box, Label: $label');
    });
  }

  Map<String, String> processResponse(List<Map<String, dynamic>> response) {
    Map<String, String> result = {};

    // Group the response by box coordinates
    Map<String, List<Map<String, dynamic>>> groupedByBox = {};
    for (var item in response) {
      String box = '${item['x_min']}-${item['y_min']}-${item['x_max']}-${item['y_max']}';
      groupedByBox.putIfAbsent(box, () => []).add(item);
    }

    // Choose the label with the best confidence for each group
    groupedByBox.forEach((box, items) {
      double maxConfidence = double.negativeInfinity;
      String selectedLabel = '';

      for (var item in items) {
        if (item['confidence'] > maxConfidence) {
          maxConfidence = item['confidence'];
          selectedLabel = item['label'];
        }
      }

      result[box] = selectedLabel;
    });

    return result;
  }
}