enum Categories {
  economy("Economy"),
  politics("Politics"),
  games("Games"),
  musics("Musics"),
  history("History"),
  books("Books"),
  others("Others"),
  foods("Foods");

  final String value;
  const Categories(this.value);

  static Categories? fromString(String category) {
    for (final cat in Categories.values) {
      if (cat.value == category) {
        return cat;
      }
    }
    return null;
  }
}

bool isValidCategory(String category) {
  return Categories.values.any((element) {
    return element.value == category;
  });
}
