import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

String baseURL = "http://127.0.0.1:3000";
// String baseURL = "http://45.76.82.152:3000";

Future<String?> uploadPicture(
  Uint8List picture,
) async {
  var url = Uri.parse('$baseURL/tag/uploadCollarTagPicture');
  // print("URL: " + url.toString());
  // String? token = await getToken();

  var request = http.MultipartRequest('POST', url);

  // request.headers['Authorization'] = 'Bearer $token';

  request.files.add(http.MultipartFile.fromBytes('picture', picture,
      filename: "tagpicture", contentType: MediaType('image', 'png')));

  StreamedResponse streamedResonse = await request.send();
  Response response = await http.Response.fromStream(streamedResonse);

  if (response.statusCode == 201) {
    print(response.body);
    return response.body;
  }
}

Future<int> createNewPetProfile(
    String activationCode, String collarTagId, String picturePath) async {
  Uri url = Uri.parse('$baseURL/tag/createTag');

  final response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
    },
    body: {
      'activationCode': activationCode,
      'collarTag_id': collarTagId,
      'picturePath': picturePath,
    },
  );

  if (response.statusCode == 201) {
    return 0;
  } else {
    return 1;
  }
}

Future<bool> isTagIdAvailable(String tagId) async {
  if (tagId.isNotEmpty) {
    var url = Uri.parse('$baseURL/tag/checkTagId/$tagId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Error();
    } else {
      if (response.body == 'true') {
        return true;
      } else {
        return false;
      }
    }
  } else {
    return false;
  }
}

String generateActivationCode(int length) {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
