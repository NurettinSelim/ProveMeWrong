import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Transform.rotate(
              angle: -0.0523,
              child: Container(
                margin: EdgeInsets.only(bottom: 100),
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 350,
                  height: 200,
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
                        Row(
                          children: [
                            Text(
                              "E-MAIL:",
                              style: TextStyle(
                                fontFamily: "SpaceMono",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 24),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppColors.tertiary,
                                  contentPadding: EdgeInsets.all(4),
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
                            Text(
                              "PASSWORD:",
                              style: TextStyle(
                                fontFamily: "SpaceMono",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                obscureText: !isVisible,
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
                                    color: Colors.black,
                                    iconSize: 16,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
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
                            SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
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
                      ],
                    ),
                  ),
                ),
                //signup cardı
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
          ],
        ),
      ),
    );
  }
}
//999