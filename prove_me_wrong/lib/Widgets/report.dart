import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

abstract interface class ReportReasons {
  String get message;
  int get value;
  bool get isMessage;
}

enum RoomReportReasons implements ReportReasons {
  wrongTopic("Topic does not match with the title", 6),
  inappropriateTitle("The title is inappropriate", 10);

  @override
  final String message;
  @override
  final int value;
  @override
  final bool isMessage = false;
  const RoomReportReasons(this.message, this.value);
}

enum MessageReportReasons implements ReportReasons {
  badLanguage("Message contains bad language", 10);

  @override
  final String message;
  @override
  final int value;
  @override
  final isMessage = true;
  const MessageReportReasons(this.message, this.value);
}

class ReportPopUp extends StatelessWidget {
  ReportPopUp({
    super.key,
    required this.reportedUserID,
    required this.reportedRoomID,
    required this.reasons,
    this.message,
    this.title,
    this.category,
  });
  final List<ReportReasons> reasons;
  String reportedRoomID;
  String reportedUserID;
  String? reportedMessageID;
  String? message;
  String? title;

  Categories? category;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Icon(Icons.more_vert, size: 16),
      onSelected: (value) {
        showModalBottomSheet(
          context: context,
          builder: (context) => ReportWidget(
            reportedUserID: reportedUserID,
            reportedRoomID: reportedRoomID,
            reportedMessageID: reportedMessageID,
            reasons: reasons,
            message: message,
            title: title,
            category: category,
          ),
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: "report", child: Text("Report")),
      ],
    );
  }
}

Future<String> report(
  String reportedUserID,
  String roomID,
  int reportScore, {
  String? messageID,
  String? message,
  String? title,
  Categories? category,
}) async {
  final userDb = FirebaseDatabase.instance.ref("users");

  try {
    final reportedUserSnap = await userDb
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("reportedUsers/$reportedUserID")
        .get();
    if (reportedUserSnap.exists) {
      return "You already report that user. We are inspecting the reports";
    }
  } catch (e) {
    return "Something went wrong. Please try again later.";
  }

  Map<String, dynamic> reportMap = {"roomID": roomID};

  if (messageID != null) {
    reportMap["messageID"] = messageID;
    reportMap["message"] = message;
    reportMap["isMessage"] = true;
  } else {
    reportMap["title"] = title;
    reportMap["category"] = category!.value;
    reportMap["isMessage"] = false;
  }
  await userDb.child(reportedUserID).child("reports").push().set(reportMap);
  await userDb.child(reportedUserID).child("reportScore").runTransaction((
    value,
  ) {
    if (value == null) {
      return Transaction.success(reportScore);
    }
    return Transaction.success((value as int) + reportScore);
  });

  await userDb
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("reportedUsers/$reportedUserID")
      .set(true);

  return "Succesfully reported";
}

class ReportWidget extends StatefulWidget {
  ReportWidget({
    super.key,
    required this.reportedRoomID,
    required this.reportedUserID,
    required this.reasons,
    this.reportedMessageID,
    this.message,
    this.title,
    this.category,
  });
  String reportedRoomID;
  String reportedUserID;
  String? reportedMessageID;
  final List<ReportReasons> reasons;
  String? message;
  String? title;
  Categories? category;
  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  final Set<ReportReasons> selectedReasons = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Text(
            "Reason for report: ",
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Space Mono",
              color: AppColors.onSecondary,
            ),
          ),
          SizedBox(height: 12),
          ...widget.reasons.map((reason) {
            return Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ChoiceChip(
                  backgroundColor: AppColors.onPrimary,
                  selectedColor: AppColors.onSecondary,
                  label: Text(
                    reason.message,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Space Mono",
                      color: Colors.black,
                    ),
                  ),
                  selected: selectedReasons.contains(reason),
                  onSelected: (value) {
                    if (selectedReasons.contains(reason)) {
                      selectedReasons.remove(reason);
                    } else {
                      selectedReasons.add(reason);
                    }
                    setState(() {});
                  },
                ),
              ),
            );
          }),
          Spacer(),
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
              int reportScore = 0;
              for (ReportReasons r in selectedReasons) {
                reportScore += r.value;
              }
              if (reportScore == 0) {
                return;
              }
              String reportMessage = await report(
                widget.reportedUserID,
                widget.reportedRoomID,
                reportScore,

                category: widget.category,
                message: widget.message,
                messageID: widget.reportedMessageID,
                title: widget.title,
              );

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(reportMessage)));
            },
            child: Text(
              "Report",
              style: TextStyle(
                fontFamily: "Space Mono",
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
