import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageMethods {
  final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/your-cloud-name/image/upload";
  final String cloudinaryPreset = "your-upload-preset";

  Future<String> uploadImageToStorage(
      bool isPost,
      String childName,
      Uint8List file,
  ) async {
    if (cloudinaryUrl.contains('your-cloud-name') ||
        cloudinaryPreset == 'your-upload-preset') {
      throw Exception(
        'Cloudinary is not configured. Replace your-cloud-name and your-upload-preset in user_storage.dart',
      );
    }

    String uniqueId = const Uuid().v1();
    var uri = Uri.parse(cloudinaryUrl);
    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = cloudinaryPreset;
    request.fields['folder'] = childName;
    request.fields['public_id'] = isPost ? uniqueId : '';

    var multipartFile = http.MultipartFile.fromBytes('file', file, filename: '$uniqueId.jpg');
    request.files.add(multipartFile);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(String.fromCharCodes(responseData));
      return jsonResponse['secure_url'];
    } else {
      throw Exception(
        'Failed to upload image to Cloudinary (${response.statusCode}): ${String.fromCharCodes(responseData)}',
      );
    }
  }
}
