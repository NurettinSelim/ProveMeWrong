//ratecard

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class RateCard extends StatefulWidget {
  final String ratedId;

  const RateCard({super.key, required this.ratedId});

  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  //final userID = FirebaseAuth.instance.currentUser!.uid;

  //  Rate hesaplarını ve database yazma işini chat screene
  //  RateCard ı açan fonksiyona taşıdım. calculateRate burda çağrılmıyor.
  Future<void> calculateRate(String id, int newScore) async {
    //roomdaki ownerScoreu da güncellemek lazım
    //final currentUser = FirebaseAuth.instance.currentUser;
    final ratingRef = FirebaseDatabase.instance.ref("users/$id/rating");

    await ratingRef.runTransaction((mutableData) {
      Map<String, dynamic> data;

      data = Map<String, dynamic>.from(mutableData as Map);

      int totalS = (data['total'] ?? 0) + newScore;
      int count = (data['count'] ?? 0) + 1;
      double avg = totalS / count;

      data = {"total": totalS, "count": count, "score": avg};

      return Transaction.success(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("0 = Worst to 5 = Best"),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final isSelected = index <= selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = index);
                  },

                  /*
                  child: Icon(
                    Icons.star,
                    color: isSelected
                        ? const Color.fromARGB(255, 251, 215, 38)
                        : Colors.grey,
                  ),
                  */
                  child: Image.asset(
                    isSelected
                        ? "lib/assets/icons/s_filled_tomato.png"
                        : "lib/assets/icons/s_empty_tomato.png",
                    width: 28,
                    height: 28,
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                final addScore = selectedIndex + 1;
                Navigator.pop(context, addScore);
              },
              child: const Text(
                "Send",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
