import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Screens/chat_screen.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/widgets/room_card.dart';
import 'package:prove_me_wrong/Screens/sign_up.dart';
import 'package:prove_me_wrong/Screens/home_screen.dart';

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

  final List<StreamSubscription> _subscriptions = [];

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
    final childAddedSubscription = userDb.child("rooms").onChildAdded.listen((
      event,
    ) async {
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

      final notificationSubscription = notificationRef.onValue
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
      _subscriptions.add(notificationSubscription);
    });
    _subscriptions.add(childAddedSubscription);

    final childRemovedSubscription = userDb
        .child("rooms")
        .onChildRemoved
        .listen((event) {
          String removedId = event.snapshot.value as String;
          roomAndNotifications.removeWhere((element) {
            return element.room.roomId == removedId;
          });
          setState(() {});
        });
    _subscriptions.add(childRemovedSubscription);
  }

  // cancel all subscriptions
  Future<void> _cancelAllSubscriptions() async {
    for (var subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  @override
  void dispose() {
    _cancelAllSubscriptions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.onPrimary),
      drawer: Drawer(
        backgroundColor: AppColors.onPrimary,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            DrawerHeader(
              child: Container(
                //padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                alignment: Alignment.bottomLeft,
                //width: double.infinity,
                height: 15,
                //decoration: BoxDecoration(shape: BoxShape.rectangle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ACCOUNT",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "SpaceMono",
                        fontSize: 24,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "INFO",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "SpaceMono",
                        fontSize: 24,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 124),
            Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              //width: double.infinity,
              //height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color.fromARGB(225, 216, 112, 112),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text(
                currentUser!.email!,
                style: TextStyle(
                  fontFamily: "Azer29LT",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              alignment: Alignment.center,
              //width: double.infinity,
              //height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color.fromARGB(225, 216, 112, 112),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rating: ",
                        style: TextStyle(
                          fontFamily: "Azer29LT",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Total Score: ",
                        style: TextStyle(
                          fontFamily: "Azer29LT",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<DatabaseEvent>(
                        stream: FirebaseDatabase.instance
                            .ref("users/${currentUser!.uid}/rating/total")
                            .onValue,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          final data = snapshot.data!.snapshot.value;

                          if (data == null) return SizedBox.shrink();

                          return Text(
                            data.toString(),
                            style: TextStyle(
                              fontFamily: "Azer29LT",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),

                      StreamBuilder<DatabaseEvent>(
                        stream: FirebaseDatabase.instance
                            .ref("users/${currentUser!.uid}/rating/total")
                            .onValue,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          final data = snapshot.data!.snapshot.value;

                          if (data == null) return SizedBox.shrink();

                          return Text(
                            data.toString(),
                            style: TextStyle(
                              fontFamily: "Azer29LT",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 124),
            Column(
              spacing: 10,
              children: [
                SizedBox(
                  //width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String snackBarMessage =
                          "We sent a link to your E-mail to reset your password.";
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: currentUser!.email!,
                        );
                      } catch (e) {
                        snackBarMessage = "Please enter valid e-mail.";
                      }
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(snackBarMessage)));
                    }, //TODO: Sonrasında signupa mı dönmeli yoksa oturum açık olarak kalmalı mı?
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiary,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    child: Text(
                      "RESET YOUR PASSWORD",
                      style: const TextStyle(
                        fontFamily: "Azer29LT",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.onPrimary,
                        title: const Text("Are you sure?"),
                        content: Text(
                          "You will be redirected to the login page.",
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                AppColors.primary,
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // Dialog kapat

                              // Cancel all subscriptions before signing out
                              await _cancelAllSubscriptions();

                              await FirebaseAuth.instance.signOut();
                            },
                            style: ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                AppColors.onPrimary,
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                AppColors.primary,
                              ),
                            ),
                            child: Text("Sure"),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    child: Text(
                      "SIGN OUT",
                      style: const TextStyle(
                        fontFamily: "Azer29LT",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
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
                          child: Visibility(
                            visible:
                                roomAndNotifications[index].notificationCount >
                                0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  "lib/assets/icons/s_filled_tomato.png",
                                  width: 32,
                                  height: 32,
                                ),

                                Text(
                                  roomAndNotifications[index].notificationCount
                                      .toString(),
                                  style: TextStyle(
                                    fontFamily: "SpaceMono",
                                    color: AppColors.onSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
