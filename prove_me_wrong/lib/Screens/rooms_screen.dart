import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Widgets/room_card.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "My Rooms(1/7)",
            style: TextStyle(
              fontFamily: "SpaceMono",
              fontStyle: .italic,
              fontSize: 32,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              RoomCard(
                room: Room(
                  category: Categories.books,
                  language: Languages.turkish,
                  ownerScore: 78,
                  title: "Sen Yalancısın",
                ),
              ),
              Positioned(
                top: -15,
                right: -10,
                child: Stack(
                  alignment: .center,
                  children: [
                    Icon(Icons.circle_rounded, color: Colors.red, size: 32),
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
          ),
        ],
      ),
    );
  }
}
