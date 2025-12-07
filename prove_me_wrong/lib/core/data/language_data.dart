enum Languages {
  german("de"),
  france("fr"),
  english("eng"),
  turkish("tr");

  final String value;
  const Languages(this.value);

  static Languages? fromString(String value) {
    for (final lang in Languages.values) {
      if (lang.value == value) {
        return lang;
      }
    }
    return null;
  }
}

bool isValidLanguage(String language) {
  return Languages.values.any((element) {
    return element.value == language;
  });
}
