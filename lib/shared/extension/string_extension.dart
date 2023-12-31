extension StringNullableExtension on String? {
  String get orEmpty => this ?? '';
}

extension StringExtension on String {
  String get capitalize => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}
