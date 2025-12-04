import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  String? selectedLanguage;
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
                      child: TextField(
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
            onPressed: () {},
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
