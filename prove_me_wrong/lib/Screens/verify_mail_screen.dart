import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class VerifyMailScreen extends StatefulWidget {
  const VerifyMailScreen({super.key});

  @override
  State<VerifyMailScreen> createState() => _VerifyMailScreenState();
}

class _VerifyMailScreenState extends State<VerifyMailScreen> {
  int remainingSeconds = 120;
  Timer? _timer;

  Timer verifyCheckTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
    FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      timer.cancel();
    }
  });

  void startTimer() {
    setState(() {
      remainingSeconds = 120;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds -= 1;
      });
      if (remainingSeconds <= 0) {
        timer.cancel();
        _timer = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    verifyCheckTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrimary,
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      backgroundColor: AppColors.onPrimary,
      body: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(
              "We sent you a vertification mail. Please check your mail.",
              style: TextStyle(
                color: const Color.fromARGB(178, 0, 0, 0),
                fontWeight: .normal,
                fontSize: 16,
              ),
              textAlign: .center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _timer == null
                  ? () async {
                      startTimer();
                    }
                  : null,

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(25),
                  side: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Text(
                "Reset Password",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 12),
            _timer != null
                ? Text("You can send again after $remainingSeconds seconds")
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
