import 'package:flutter/material.dart';
import 'package:kub_chef/data/models/scan_result.dart';

class SuggestionsProvider extends ChangeNotifier {
  ScanResult? current;
  void setResult(ScanResult r) {
    current = r;
    notifyListeners();
  }
}
