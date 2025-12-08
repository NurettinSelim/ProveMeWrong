import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Widgets/room_card.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  late final userDb = FirebaseDatabase.instance.ref(
    "users/${currentUser!.uid}",
  );

  List<Room> rooms = [];

  @override
  void initState() {
    final roomDb = FirebaseDatabase.instance.ref("rooms");
    userDb.child("rooms").onChildAdded.listen((event) async {
      final DataSnapshot roomSnap;
      try {
        roomSnap = await roomDb.child("${event.snapshot.value}").get();
      } catch (e) {
        return;
      }
      final roomMap = roomSnap.value as LinkedHashMap;
      final category = Categories.fromString(roomMap["category"]);
      final language = Languages.fromString(roomMap["language"]);

      //  Bozuk veri. Sonra buraya oda silme eklenebilir
      if (category == null || language == null) {
        return;
      }
      rooms.add(
        Room(
          ownerScore: roomMap["ownerScore"],
          title: roomMap["title"],
          category: category,
          language: language,
        ),
      );
    });

    userDb.child("rooms").onChildRemoved.listen((event) {
      String removedId = event.snapshot.value as String;
      for (int i = 0; i < rooms.length; i++) {
        if (rooms[i].roomId == removedId) {
          rooms.removeAt(i);
          return;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "My Rooms(${rooms.length}/7)",
            style: TextStyle(
              fontFamily: "SpaceMono",
              fontStyle: .italic,
              fontSize: 32,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    RoomCard(
                      room: Room(
                        category: rooms[index].category,
                        language: rooms[index].language,
                        ownerScore: rooms[index].ownerScore,
                        title: rooms[index].title,
                      ),
                    ),
                    Positioned(
                      top: -15,
                      right: -10,
                      child: Stack(
                        alignment: .center,
                        children: [
                          Icon(
                            Icons.circle_rounded,
                            color: Colors.red,
                            size: 32,
                          ),
                          Text(
                            "570",
                            style: TextStyle(
                              fontFamily: "Azer29LT",
                              color: AppColors.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
