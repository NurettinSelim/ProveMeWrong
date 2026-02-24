import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Screens/chat_screen.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/widgets/room_card.dart';

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

  void onEnter(String roomID) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ChatScreen(
          rooms: rooms.firstWhere((element) {
            return element.roomId == roomID;
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
      final ownerID = roomMap["ownerID"];
      final guestID = roomMap["guestID"];
      //  Bozuk veri. Sonra buraya oda silme eklenebilir
      if (category == null || language == null) {
        return;
      }
      rooms.add(
        Room(
          roomId: roomSnap.key as String,
          ownerId: ownerID,
          guestId: guestID ?? "",
          ownerScore: roomMap["ownerScore"],
          title: roomMap["title"],
          category: category,
          language: language,
        ),
      );
      setState(() {});
    });

    userDb.child("rooms").onChildRemoved.listen((event) {
      String removedId = event.snapshot.value as String;
      for (int i = 0; i < rooms.length; i++) {
        if (rooms[i].roomId == removedId) {
          setState(() {
            rooms.removeAt(i);
          });
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Rooms(${rooms.length}/7)",
            style: TextStyle(
              fontFamily: "SpaceMono",
              fontStyle: FontStyle.italic,
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
                  key: ValueKey(rooms[index].roomId),
                  clipBehavior: Clip.none,
                  children: [
                    RoomCard(
                      room: rooms[index],
                      showPopUp: false,
                      onEnter: onEnter,
                    ),
                    Positioned(
                      top: -15,
                      right: -10,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "lib/assets/icons/s_filled_tomato.png",
                            width: 32,
                            height: 32,
                          ),
                          Text(
                            "570",
                            style: TextStyle(
                              fontFamily: "Azer29LT",
                              color: AppColors.onPrimary,
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
