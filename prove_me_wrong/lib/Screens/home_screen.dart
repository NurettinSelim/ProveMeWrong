import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Widgets/category_grid.dart';
import 'package:prove_me_wrong/Widgets/room_card.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/data/language_data.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    SizedBox(height: 80, child: CategoryGrid()),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
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
                      "RANDOM",
                      style: TextStyle(
                        color: AppColors.onSecondary,
                        fontFamily: "SpaceMono",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              RoomCard(
                room: Room(
                  category: Categories.books,
                  language: Languages.turkish,
                  ownerScore: 78,
                  title: "Sen Yalancısın",
                ),
              ),
              SizedBox(height: 8),
              RoomCard(
                room: Room(
                  category: Categories.books,
                  language: Languages.turkish,
                  ownerScore: 78,
                  title: "Sen Yalancısın",
                ),
              ),
              SizedBox(height: 8),
              RoomCard(
                room: Room(
                  category: Categories.books,
                  language: Languages.turkish,
                  ownerScore: 78,
                  title: "Sen Yalancısın",
                ),
              ),
              SizedBox(height: 8),
              RoomCard(
                room: Room(
                  category: Categories.books,
                  language: Languages.turkish,
                  ownerScore: 78,
                  title: "Sen Yalancısın",
                ),
              ),
              SizedBox(height: 8),
              RoomCard(
                room: Room(
                  category: Categories.books,
                  language: Languages.turkish,
                  ownerScore: 78,
                  title: "Sen Yalancısın",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
