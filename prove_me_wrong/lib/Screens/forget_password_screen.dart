import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:prove_me_wrong/core/theme/app_theme.dart";

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      backgroundColor: AppColors.onPrimary,
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                "Reset Your Password",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: .bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Enter your Email adress. We will send you a link to reset your password.",
                style: TextStyle(
                  color: const Color.fromARGB(178, 0, 0, 0),
                  fontWeight: .normal,
                  fontSize: 16,
                ),
                textAlign: .center,
              ),
              SizedBox(height: 16),
              TextField(
                controller: mailController,

                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  labelText: "E-mail",
                  labelStyle: TextStyle(color: Colors.black),

                  fillColor: AppColors.tertiary,
                  contentPadding: EdgeInsets.all(12),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () async {
                  String snackBarMessage =
                      "We sent a link to your E-mail to reset your password.";
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: mailController.text.trim(),
                    );
                  } catch (e) {
                    snackBarMessage = "Please enter valid e-mail.";
                  }
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(snackBarMessage)));
                },

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
            ],
          ),
        ),
      ),
    );
  }
}
