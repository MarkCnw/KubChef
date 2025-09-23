import 'dart:io';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/scan_result.dart';

/// ตั้งค่า endpoint n8n Webhook ของคุณ
class N8nConfig {
  static const String baseUrl = String.fromEnvironment(
    'N8N_BASE_URL',
    defaultValue: 'https://YOUR-N8N-HOST',
  );
  static const String webhookPath = '/webhook/scan-to-recipe';
  static String get endpoint => '$baseUrl$webhookPath';
  static const String apiKey = String.fromEnvironment(
    'N8N_API_KEY',
    defaultValue: '',
  );
}

class N8nApi {
  /// ส่งรูปไปที่ n8n และรับผลลัพธ์วิเคราะห์
  static Future<ScanResult> analyzeImage(File image) async {
    final uri = Uri.parse(N8nConfig.endpoint);
    final req = http.MultipartRequest('POST', uri);
    req.files.add(await http.MultipartFile.fromPath('file', image.path));
    if (N8nConfig.apiKey.isNotEmpty) {
      req.headers['x-api-key'] = N8nConfig.apiKey;
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> data =
          json.decode(res.body) as Map<String, dynamic>;
      return ScanResult.fromJson(data);
    }

    // fallback mock สำหรับ dev หาก backend ยังไม่พร้อม
    return ScanResult.fromJson({
      'ingredients': ['Tomato', 'Basil', 'Garlic', 'Olive Oil', 'Pasta'],
      'recipes': [
        {
          'id': '1',
          'title': 'Caprese Pasta',
          'imageUrl':
              'https://images.unsplash.com/photo-1523986371872-9d3ba2e2f642',
          'timeMinutes': 30,
          'servings': 2,
          'ingredients': [
            '200g pasta',
            '100g cherry tomatoes',
            '50g basil',
            '2 cloves garlic',
          ],
          'steps': [
            'Cook pasta until al dente. Drain.',
            'Sauté garlic, add tomatoes & basil.',
            'Toss pasta with sauce and serve.',
          ],
        },
      ],
    });
  }
}
