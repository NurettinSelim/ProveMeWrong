import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Screens/chat_screen.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/widgets/room_card.dart';

class RoomAndNotification {
  final Room room;
  int notificationCount;

  RoomAndNotification(this.room, this.notificationCount);
}

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

  final roomAndNotifications = <RoomAndNotification>[];

  void onEnter(Room room) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => ChatScreen(rooms: room)),
    );
  }

  @override
  void initState() {
    super.initState();

    //
    //  Direk rooms u okumak mesajlarıda gereksiz yere okuyor. Onun için
    //  ihtiyacımız olan kısımları tek tek okuyoruz
    //
    userDb.child("rooms").onChildAdded.listen((event) async {
      final baseRef = FirebaseDatabase.instance.ref(
        "rooms/${event.snapshot.key}",
      );

      final category = Categories.fromString(
        (await baseRef.child("category").get()).value as String,
      );
      final language = Languages.fromString(
        (await baseRef.child("language").get()).value as String,
      );
      final ownerID = (await baseRef.child("ownerID").get()).value as String;
      final guestID = (await baseRef.child("guestID").get()).value as String?;
      final title = (await baseRef.child("title").get()).value as String;
      final ownerScore = (await baseRef.child("ownerScore").get()).value as int;

      final notificationRef = currentUser!.uid == ownerID
          ? baseRef.child("ownerNotificationCount")
          : baseRef.child("guestNotificationCount");

      int? notificationCount = (await notificationRef.get()).value as int?;
      final roomAndNotification = RoomAndNotification(
        Room(
          roomId: event.snapshot.key!,
          ownerId: ownerID,
          guestId: guestID ?? "",
          ownerScore: ownerScore,
          title: title,
          category: category!,
          language: language!,
        ),
        notificationCount ?? 0,
      );

      roomAndNotifications.add(roomAndNotification);
      setState(() {});
      notificationRef.onValue
          .where((event) {
            return event.snapshot.exists &&
                roomAndNotification.notificationCount !=
                    (event.snapshot.value as int);
          })
          .listen((event) {
            roomAndNotification.notificationCount = event.snapshot.value as int;
            roomAndNotifications.sort((a, b) {
              return b.notificationCount.compareTo(a.notificationCount);
            });
            setState(() {});
          });
    });

    userDb.child("rooms").onChildRemoved.listen((event) {
      String removedId = event.snapshot.value as String;
      roomAndNotifications.removeWhere((element) {
        return element.room.roomId == removedId;
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.onPrimary),
      drawer: Drawer(
        backgroundColor: AppColors.primary,
        child: ListView(
          children: [
            DrawerHeader(
              child: Container(
                //padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                alignment: Alignment.center,
                //width: double.infinity,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color.fromARGB(225, 237, 227, 215),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  "Account Info",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "SpaceMono",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              alignment: Alignment.center,
              //width: double.infinity,
              //height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppColors.onPrimary,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text(currentUser!.email!),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              alignment: Alignment.center,
              //width: double.infinity,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppColors.onPrimary,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text("data"),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.onPrimary,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Rooms(${roomAndNotifications.length}/7)",
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
                itemCount: roomAndNotifications.length,
                itemBuilder: (context, index) {
                  return Padding(
                    key: ValueKey(roomAndNotifications[index].room.roomId),
                    padding: EdgeInsetsGeometry.all(6),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        RoomCard(
                          room: roomAndNotifications[index].room,
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
