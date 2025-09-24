import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // เพิ่ม import นี้
import 'package:image_picker/image_picker.dart';
import 'package:kub_chef/data/models/scan_result.dart';

class ScanProvider extends ChangeNotifier {
  final _picker = ImagePicker();
  File? image;
  bool loading = false;
  String? error;
  ScanResult? result;

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

  Future<ScanResult?> analyze() async { 
    if (image == null) return null;
    
    try {
      loading = true;
      error = null;
      notifyListeners();

      // เปลี่ยน URL ตามสภาพแวดล้อม
      String baseUrl;
      if (kDebugMode) {
        // สำหรับ development
        if (Platform.isAndroid) {
          baseUrl = 'http://10.0.2.2:5678'; // Android Emulator
        } else if (Platform.isIOS) {
          baseUrl = 'http://localhost:5678'; // iOS Simulator
        } else {
          baseUrl = 'http://localhost:5678'; // อื่นๆ
        }
      } else {
        // สำหรับ production
        baseUrl = 'https://your-n8n-host.com';
      }

      final uri = Uri.parse('$baseUrl/webhook-test/scan-to-recipe');
      print('Sending request to: $uri'); // เพื่อ debug
      print('File path: ${image!.path}'); // เพื่อ debug

      final request = http.MultipartRequest('POST', uri);
      
      // เพิ่ม headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });
      
      // เพิ่มไฟล์
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // ต้องตรงกับ field name ใน n8n
          image!.path,
          filename: 'image.jpg',
          // บังคับ mime type ให้เป็น image/jpeg
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      print('Sending file: ${image!.path}'); // เพื่อ debug

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}'); // เพื่อ debug
      print('Response body: $respStr'); // เพื่อ debug

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
        error = 'Upload failed: ${response.statusCode}\nResponse: $respStr';
        return null;
      }
    } catch (e) {
      loading = false;
      error = 'Network error: $e';
      notifyListeners();
      print('Error: $e'); // เพื่อ debug
      return null;
    }
  }
}