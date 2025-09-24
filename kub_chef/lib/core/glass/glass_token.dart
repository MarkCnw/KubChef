import 'dart:ui';
import 'package:flutter/material.dart';

class GlassTokens extends ThemeExtension<GlassTokens> {
  final Gradient backgroundGradient;
  final Gradient sheetGradient;
  final Color baseGlassColor;
  final double blurSigma;
  final double borderOpacity;
  final double tintOpacity;
  final BorderRadius defaultRadius;
  final BorderRadius elevatedRadius;

  const GlassTokens({
    required this.backgroundGradient,
    required this.sheetGradient,
    required this.baseGlassColor,
    required this.blurSigma,
    required this.borderOpacity,
    required this.tintOpacity,
    required this.defaultRadius,
    required this.elevatedRadius,
  });

  @override
  GlassTokens copyWith({
    Gradient? backgroundGradient,
    Gradient? sheetGradient,
    Color? baseGlassColor,
    double? blurSigma,
    double? borderOpacity,
    double? tintOpacity,
    BorderRadius? defaultRadius,
    BorderRadius? elevatedRadius,
  }) {
    return GlassTokens(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      sheetGradient: sheetGradient ?? this.sheetGradient,
      baseGlassColor: baseGlassColor ?? this.baseGlassColor,
      blurSigma: blurSigma ?? this.blurSigma,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      tintOpacity: tintOpacity ?? this.tintOpacity,
      defaultRadius: defaultRadius ?? this.defaultRadius,
      elevatedRadius: elevatedRadius ?? this.elevatedRadius,
    );
  }

  @override
  ThemeExtension<GlassTokens> lerp(
    ThemeExtension<GlassTokens>? other,
    double t,
  ) {
    if (other is! GlassTokens) return this;
    return GlassTokens(
      backgroundGradient: _lerpGradient(
        backgroundGradient,
        other.backgroundGradient,
        t,
      ),
      sheetGradient: _lerpGradient(sheetGradient, other.sheetGradient, t),
      baseGlassColor: Color.lerp(baseGlassColor, other.baseGlassColor, t)!,
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t)!,
      borderOpacity: lerpDouble(borderOpacity, other.borderOpacity, t)!,
      tintOpacity: lerpDouble(tintOpacity, other.tintOpacity, t)!,
      defaultRadius: BorderRadius.lerp(
        defaultRadius,
        other.defaultRadius,
        t,
      )!,
      elevatedRadius: BorderRadius.lerp(
        elevatedRadius,
        other.elevatedRadius,
        t,
      )!,
    );
  }

  static Gradient _lerpGradient(Gradient a, Gradient b, double t) {
    if (a is LinearGradient && b is LinearGradient) {
      // ผสมสีตามจำนวน max ของทั้งสอง gradient
      final int maxLen = a.colors.length > b.colors.length
          ? a.colors.length
          : b.colors.length;
      List<Color> lerped = List.generate(maxLen, (i) {
        final ca = a.colors[i % a.colors.length];
        final cb = b.colors[i % b.colors.length];
        return Color.lerp(ca, cb, t)!;
      });

      return LinearGradient(
        colors: lerped,
        stops: _mergeStops(a.stops, b.stops, maxLen, t),
        begin: AlignmentGeometry.lerp(
          a.begin,
          b.begin,
          t,
        )!, // ใช้ AlignmentGeometry.lerp
        end: AlignmentGeometry.lerp(
          a.end,
          b.end,
          t,
        )!, // ใช้ AlignmentGeometry.lerp
        tileMode: t < 0.5 ? a.tileMode : b.tileMode,
        transform: t < 0.5 ? a.transform : b.transform,
      );
    }
    // ถ้าไม่ใช่ LinearGradient (เช่น Radial/ Sweep) ให้ fallback เป็นตัวหลัง
    return b;
  }

  static List<double>? _mergeStops(
    List<double>? aStops,
    List<double>? bStops,
    int len,
    double t,
  ) {
    if (aStops == null && bStops == null) return null;
    // normalize
    List<double> genDefault(int l) =>
        List.generate(l, (i) => i / (l - 1 == 0 ? 1 : (l - 1)));

    final as = aStops ?? genDefault(len);
    final bs = bStops ?? genDefault(len);

    return List.generate(len, (i) {
      final da = as[i % as.length];
      final db = bs[i % bs.length];
      return lerpDouble(da, db, t)!;
    });
  }
}
