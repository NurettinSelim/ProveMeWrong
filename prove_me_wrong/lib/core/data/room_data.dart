import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';

class Room {
  Room({
    this.ownerId = "",
    required this.ownerScore,
    required this.title,
    required this.category,
    required this.language,
  });

  String ownerId;
  int ownerScore;
  String title;
  Categories category;
  Languages language;
}
