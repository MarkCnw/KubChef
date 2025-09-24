import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  // ✅ เปลี่ยนให้ return ScanResult
  Future<ScanResult?> analyze() async { 
    if (image == null) return null;
    try {
      loading = true;
      notifyListeners();

      final uri = Uri.parse('http://10.0.2.2:5678/webhook/scan-to-recipe');

      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('file', image!.path),
      );

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      loading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final data = jsonDecode(respStr) as Map<String, dynamic>;
        result = ScanResult.fromJson(data); // 👈 แปลงเป็น ScanResult
        return result;
      } else {
        error = 'Upload failed: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      loading = false;
      error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
