import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class StorageMethods {
  final String cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/your-cloud-name/image/upload';
  final String cloudinaryPreset = 'your-upload-preset';

  Future<String> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    final String uniqueId = const Uuid().v1();
    final Uri uri = Uri.parse(cloudinaryUrl);
    final http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = cloudinaryPreset;
    request.fields['folder'] = childName;
    request.fields['public_id'] = isPost ? uniqueId : '';

    final http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'file',
      file,
      filename: '$uniqueId.jpg',
    );
    request.files.add(multipartFile);

    final http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final List<int> responseData = await response.stream.toBytes();
      final dynamic jsonResponse =
          jsonDecode(String.fromCharCodes(responseData));
      return jsonResponse['secure_url'];
    } else {
      throw Exception('Failed to upload image to Cloudinary');
    }
  }
}
