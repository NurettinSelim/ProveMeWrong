import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Screens/forget_password_screen.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isVisible = false;
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signIn() async {
    String? errorMessage;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        errorMessage = "Please check your network connection.";
      } else {
        errorMessage = "Sign-in failed. Please check your email and password.";
      }
    } catch (e) {
      errorMessage = "Some error occured. Please try again.";
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  Future<void> signUp() async {
    String? errorMessage;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mailController.text.trim(),
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "Email is already used.";
          break;
        case "invalid-email":
          errorMessage = "Please enter valid email.";
          break;
        case "weak-password":
        case "password-does-not-meet-requirements":
          errorMessage =
              "Password must be at least 8 characters, include uppercase, lowercase, number, and special character.";
          break;
        case "too-many-requests":
          errorMessage = "You sent too many request please try again later.";
          break;
        case "network-request-failed":
          errorMessage = "Please check your network connection.";
          break;
        default:
          errorMessage = "Error occured. Please try again later.";
      }
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    User currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseDatabase.instance.ref("users/${currentUser.uid}").set({
      "roomCount": 0,
      "rating": {"total": 0, "score": 0, "count": 0},
    });
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Align(
        alignment: .topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Transform.rotate(
              angle: -0.0523,
              child: Container(
                margin: EdgeInsets.only(bottom: 70),
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                alignment: Alignment.center,
                width: 225,
                height: 330,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Transform.rotate(
                  angle: 0.0523,
                  child: Column(
                    spacing: 0,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "READY TO",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SpaceMono",
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "SMASH",
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontFamily: "HectorExtenda40",
                          fontSize: 75,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "TOMATOES TO YOUR",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SpaceMono",
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "NEMESIS",
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontFamily: "HectorExtenda40",
                          fontSize: 75,
                        ),
                      ),
                    ],
                  ),
                ), // buraya kadar transform olucak
              ),
            ),

            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 350,
                      height: 220,
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Row(
                              children: [
                                SizedBox(
                                  width: 95,
                                  child: Text(
                                    "E-MAIL:",
                                    style: TextStyle(
                                      fontFamily: "SpaceMono",
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: TextField(
                                    controller: mailController,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: AppColors.tertiary,
                                      contentPadding: EdgeInsets.all(4),
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 24,
                                        maxWidth: 24,
                                      ),
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
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                SizedBox(
                                  width: 95,
                                  child: Text(
                                    "PASSWORD:",
                                    style: TextStyle(
                                      fontFamily: "SpaceMono",
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: TextField(
                                    controller: passwordController,

                                    obscureText: !isVisible,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: AppColors.tertiary,
                                      contentPadding: EdgeInsets.all(4),

                                      suffixIconConstraints:
                                          BoxConstraints.loose(Size(24, 24)),
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
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isVisible = !isVisible;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        iconSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: signIn,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(double.infinity, 45),
                                      backgroundColor: AppColors.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        side: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SIGN IN",
                                        style: TextStyle(
                                          fontFamily: "SpaceMono",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: signUp,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(double.infinity, 45),
                                      backgroundColor: AppColors.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        side: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),

                                    child: Center(
                                      child: Text(
                                        "SIGN UP",
                                        style: TextStyle(
                                          fontFamily: "SpaceMono",
                                          fontSize: 16,
                                          color: AppColors.onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgetPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forget your password?",
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: -25,
                      left: 50,
                      right: 50,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(2),
                            child: Text(
                              "PROVE ME WRONG",
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontFamily: "HectorExtenda40",
                                fontSize: 48,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: const Color.fromARGB(255, 179, 178, 178),
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: "By creating an account, you agree to our ",
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final Uri _url = Uri.parse(
                              "https://bogo-provemewrong.github.io/privacy-policy/",
                            );
                            await launchUrl(_url);
                          },
                      ),
                      TextSpan(text: "."),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//999