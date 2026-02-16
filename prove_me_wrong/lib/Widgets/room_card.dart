import 'package:flutter/material.dart';
import 'package:prove_me_wrong/widgets/report.dart';
import 'package:prove_me_wrong/core/data/room_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.room,
    this.onEnter,
    this.showPopUp = true,
  });

  final bool showPopUp;
  final Room room;
  final void Function(String roomId)? onEnter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
        border: BoxBorder.all(width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          showPopUp
              ? Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: ReportPopUp(
                    reasons: RoomReportReasons.values,
                    reportedRoomID: room.roomId,
                    reportedUserID: room.ownerId,
                    category: room.category,
                    title: room.title,
                  ),
                )
              : const SizedBox.shrink(),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              room.title,
              style: TextStyle(
                color: AppColors.onSecondary,
                fontSize: 18,
                fontFamily: "Azer29LT",
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "(${room.ownerScore}) | ${room.language.value} | ${room.category.value}",
                style: TextStyle(
                  color: AppColors.onSecondary,
                  fontFamily: "Azer29LT",
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {
                  onEnter?.call(room.roomId);
                },
                child: Text(
                  "Enter",
                  style: TextStyle(
                    color: AppColors.onSecondary,
                    fontFamily: "Azer29LT",
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
