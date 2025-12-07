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
}

bool isValidCategory(String category) {
  return Categories.values.any((element) {
    return element.value == category;
  });
}
