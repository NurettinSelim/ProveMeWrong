//ratecard

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RateCard extends StatefulWidget {
  final String raterId;

  const RateCard({super.key, required this.raterId});

  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  final userID = FirebaseAuth.instance.currentUser!.uid;

  Future<void> calculateRate(String id, int newScore) async {
    //roomdaki ownerScoreu da güncellemek lazım
    //final currentUser = FirebaseAuth.instance.currentUser;
    final ratingRef = FirebaseDatabase.instance.ref("users/$id/rating");

    await ratingRef.runTransaction((mutableData) {
      Map<String, dynamic> data;

      if (mutableData == null) {
        data = {"total": newScore, "count": 1, "score": newScore};
      } else {
        data = Map<String, dynamic>.from(mutableData as Map);

        int totalS = (data['total'] ?? 0) + newScore;
        int count = (data['count'] ?? 0) + 1;
        double avg = totalS / count;

        data = {"total": totalS, "count": count, "score": avg};
      }

      return Transaction.success(mutableData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
