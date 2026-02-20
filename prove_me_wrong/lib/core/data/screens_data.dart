import 'package:flutter_riverpod/legacy.dart';

enum Screens { homeScreen, roomsScreen }

final screenProvider = StateProvider<Screens>((ref) => Screens.homeScreen);
