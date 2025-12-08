import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';

class Room {
  Room({
    //  Hepsi required olucak. Anlık olarak kod bozulmasın diye böyle
    this.ownerId = "",
    this.roomId = "",
    required this.ownerScore,
    required this.title,
    required this.category,
    required this.language,
  });

  String ownerId;
  String roomId;
  int ownerScore;
  String title;
  Categories category;
  Languages language;
}
