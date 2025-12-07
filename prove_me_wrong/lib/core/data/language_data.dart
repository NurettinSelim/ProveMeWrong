enum Languages {
  german("de"),
  france("fr"),
  english("eng"),
  turkish("tr");

  final String value;
  const Languages(this.value);
}

bool isValidLanguage(String language) {
  return Languages.values.any((element) {
    return element.value == language;
  });
}
