class University {
  const University({
    required this.id,
    required this.name,
    required this.country,
    required this.alphaTwoCode,
    required this.domains,
    required this.webPages,
    this.stateProvince,
  });

  /// Zero-based position in the source array; unique and order-stable.
  final int id;
  final String name;
  final String country;
  final String alphaTwoCode;
  final String? stateProvince;
  final List<String> domains;
  final List<String> webPages;
}
