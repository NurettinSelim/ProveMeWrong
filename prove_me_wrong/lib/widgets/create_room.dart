import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  String? selectedLanguage;
  String? selectedCategory;
  final titleController = TextEditingController();

  //  Returns error or success message
  Future<String> createRoom() async {
    if (selectedCategory == null || selectedLanguage == null) {
      return "Language and Category can't be empty.";
    }
    String title = titleController.text.trim();
    if (title.isEmpty) return "Title can't be empty.";
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDb = FirebaseDatabase.instance.ref("users/${currentUser!.uid}");

    DataSnapshot roomCountSnap;
    DataSnapshot ownerScoreSnap;
    try {
      roomCountSnap = await userDb.child("roomCount").get();
      ownerScoreSnap = await userDb.child("score").get();
    } catch (e) {
      return "Something went wrong. Try again later.";
    }

    if (roomCountSnap.value as int >= 7) {
      return "You can only have 7 rooms at the same time.";
    }

    final roomsRef = FirebaseDatabase.instance.ref("rooms");
    final room = roomsRef.push();

    try {
      await room.set({
        "ownerID": currentUser.uid,
        "ownerScore": ownerScoreSnap.value as int,
        "category": selectedCategory,
        "language": selectedLanguage,
        "title": title,
      });
      await userDb.child("rooms").push().set(room.key);
    } catch (e) {
      print(e);
      return "Something went wrong. Please try again later.";
    }

    return "Succesfully created the room.";
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.onPrimary,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "TITLE:",
                      style: TextStyle(fontSize: 18, fontFamily: "Space Mono"),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: titleController,

                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.tertiary,
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "CATEGORY:",
                      style: TextStyle(fontSize: 18, fontFamily: "Space Mono"),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: DropdownButtonFormField<Categories>(
                        items: Categories.values.map((cat) {
                          return DropdownMenuItem<Categories>(
                            value: cat,
                            child: Text(cat.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!.value;
                          });
                        },
                        value: selectedCategory.toString() != "null"
                            ? Categories.values.firstWhere(
                                (cat) => cat.value == selectedCategory,
                              )
                            : null,

                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.tertiary,
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "LANGUAGE:",
                      style: TextStyle(fontSize: 18, fontFamily: "Space Mono"),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: DropdownButtonFormField<Languages>(
                        items: Languages.values.map((lang) {
                          return DropdownMenuItem<Languages>(
                            value: lang,
                            child: Text(lang.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value!.value;
                          });
                        },
                        value: selectedLanguage.toString() != "null"
                            ? Languages.values.firstWhere(
                                (lang) => lang.value == selectedLanguage,
                              )
                            : null,

                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.tertiary,
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onPrimary,
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            onPressed: () async {
              final result = await createRoom();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(result)));
            },
            child: Text(
              "CREATE ROOM",
              style: TextStyle(
                fontFamily: "Space Mono",
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
