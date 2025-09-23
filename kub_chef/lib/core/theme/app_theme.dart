import 'package:flutter/material.dart';


class AppTheme {
static const _seed = Color(0xFF00C389); // เขียวมิ้นต์


static ThemeData get light => ThemeData(
colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light),
useMaterial3: true,
visualDensity: VisualDensity.adaptivePlatformDensity,
);
}