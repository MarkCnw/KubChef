import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kub_chef/data/models/scan_result.dart';

class ScanProvider extends ChangeNotifier {
  final _picker = ImagePicker();
  File? image;
  bool loading = false;
  String? error;
  ScanResult? result;

  // เลือกหรือถ่ายภาพ
  Future<void> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    error = null;
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked != null) {
      image = File(picked.path);
      notifyListeners();
    }
  }

  // วิเคราะห์ภาพ
  Future<ScanResult?> analyze() async {
    if (image == null) return null;

    try {
      loading = true;
      error = null;
      notifyListeners();

      // ✅ ตั้งค่า baseUrl ให้รองรับ Emulator
      String baseUrl;
      if (kDebugMode) {
        if (Platform.isAndroid) {
          baseUrl = 'http://10.0.2.2:5678';
        } else if (Platform.isIOS) {
          baseUrl = 'http://localhost:5678';
        } else {
          baseUrl = 'http://172.16.138.39:5678'; // สำหรับ desktop
        }
      } else {
        baseUrl = 'https://your-production-domain.com';
      }

      final uri = Uri.parse('$baseUrl/webhook/scan-to-recipe');
      print('Sending request to: $uri');
      print('File path: ${image!.path}');

      // ✅ สร้าง MultipartRequest
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        })
        ..files.add(
          await http.MultipartFile.fromPath(
            'file', // ต้องตรงกับ field name ใน n8n
            image!.path,
            filename: 'image.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $respStr');

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(respStr) as Map<String, dynamic>;
          result = ScanResult.fromJson(data);
          return result;
        } catch (parseError) {
          print('JSON Parse Error: $parseError');
          error = 'Invalid response format: $parseError';
          return null;
        }
      } else {
        error =
            'Upload failed: ${response.statusCode}\nResponse: $respStr';
        return null;
      }
    } catch (e) {
      loading = false;
      error = 'Network error: $e';
      notifyListeners();
      print('Error: $e');
      return null;
    }
  }
}
