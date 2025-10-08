String enumLabel(String value) {
  final parts = value.split('_').where((part) => part.isNotEmpty);
  final formatted = parts
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
  return formatted.isEmpty ? value : formatted;
}

String formatAsPercent(double value, {int fractionDigits = 0}) {
  final clamped = value.clamp(0, 1);
  final percent = (clamped * 100).toStringAsFixed(fractionDigits);
  return '$percent%';
}

String formatAsMultiplier(double value, {int fractionDigits = 2}) {
  return '${value.toStringAsFixed(fractionDigits)}x';
}
