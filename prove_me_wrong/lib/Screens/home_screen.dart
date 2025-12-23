import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Widgets/category_grid.dart';
import 'package:prove_me_wrong/Widgets/room_card.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final categoryList = CategoryList();
  bool listChanged = false;

  final List<Room> rooms = [];
  final Map<Categories, int> lastTime = {};

  final scrollController = ScrollController();

  final roomsDb = FirebaseDatabase.instance.ref("rooms");
  final currentUser = FirebaseAuth.instance.currentUser!;

  void onEnter(String roomId) async {
    final result = await roomsDb.child("$roomId/guestID").runTransaction((
      value,
    ) {
      if (value != null) Transaction.abort();
      return Transaction.success(currentUser.uid);
    });

    await FirebaseDatabase.instance
        .ref("users/${currentUser.uid}/rooms")
        .push()
        .set(roomId);

    final String snackMessage;
    if (result.committed) {
      rooms.removeAt(
        rooms.indexWhere((element) {
          return element.roomId == roomId;
        }),
      );
      snackMessage = "Succesfully joined the room.";
    } else {
      snackMessage = "Someone joined before you.";
    }

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(snackMessage)));
    }

    setState(() {});
  }

  void applyCategories() async {
    categoryList.listChanged = false;
    rooms.clear();
    lastTime.clear();
    await loadRooms();
  }

  bool isLoading = false;
  Future<void> loadRooms() async {
    if (isLoading) return;
    isLoading = true;
    final categoriesDb = FirebaseDatabase.instance.ref("categories");

    for (int i = 0; i < 10; i++) {
      final category =
          categoryList.categories[i % categoryList.categories.length];
      DataSnapshot categorySnap;
      if (lastTime[category] == null) {
        categorySnap = await categoriesDb
            .child(category.value)
            .orderByChild('timeStamp')
            .limitToLast(1)
            .get();
      } else {
        categorySnap = await categoriesDb
            .child(category.value)
            .orderByChild('timeStamp')
            .limitToLast(1)
            .endBefore(lastTime[category])
            .get();
      }
      if (!categorySnap.exists) {
        continue;
      }

      lastTime[category] =
          categorySnap.children.first.child('timeStamp').value as int;

      final roomSnap = await roomsDb
          .child(categorySnap.children.first.key as String)
          .get();
      LinkedHashMap roomMap = roomSnap.value as LinkedHashMap;
      if (roomMap["ownerID"] == currentUser.uid ||
          roomMap["guestID"] == currentUser.uid) {
        i -= 1;
        continue;
      }

      rooms.add(
        Room(
          category: Categories.fromString(roomMap["category"])!,
          language: Languages.fromString(roomMap["language"])!,
          ownerScore: roomMap["ownerScore"],
          title: roomMap["title"],
          ownerId: roomMap["ownerID"],
          roomId: roomSnap.key as String,
        ),
      );
    }
    setState(() {});
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    loadRooms();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        loadRooms();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(12, 24, 12, 0),
          child: Column(
            children: [
              Text(
                "I AM LOOKING TO",
                style: TextStyle(
                  fontSize: 34,
                  fontStyle: FontStyle.italic,
                  fontFamily: "SpaceMono",
                ),
              ),
              Text(
                "FIGHT ABOUT:",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 34,
                  fontFamily: "SpaceMono",
                  height: 1.2,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Categories: ",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontFamily: "SpaceMono",
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: CategoryGrid(categoryList: categoryList),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (categoryList.listChanged) {
                    applyCategories();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,

                  minimumSize: Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(6),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.autorenew_rounded, color: AppColors.onSecondary),
                    SizedBox(width: 2),
                    Text(
                      "APPLY",
                      style: TextStyle(
                        color: AppColors.onSecondary,
                        fontFamily: "SpaceMono",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ...rooms.map(
                (room) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: RoomCard(
                    key: ValueKey(room.roomId),
                    room: room,
                    onEnter: onEnter,
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
