enum Categories {
  books("Books"),
  culture("Society and Culture"),
  economy("Economy"),
  entertainment("Entertainment"),
  environment("Environment"),
  ethics("Ethics"),
  feminizm("Feminizm and LGBTQ+ Rights"),
  foods("Foods"),
  games("Games"),
  geopolitics("Geopolitics"),
  goverment("Goverment"),
  history("History"),
  ideology("Ideology"),
  law("Law and Human Rights"),
  musics("Musics"),
  philosophy("Philosophy"),
  politics("Politics"),
  sports("Sports"),
  technology("Technology"),
  others("Others");

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

class CategoryList {
  bool listChanged = false;
  List<Categories> categories = [Categories.foods];
}
