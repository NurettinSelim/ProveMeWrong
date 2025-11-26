import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                            Container(
                              height: 35,
                              margin: EdgeInsets.only(left: 30),
                              width: 190,
                              decoration: BoxDecoration(
                                color: AppColors.tertiary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
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
                            Container(
                              height: 35,
                              margin: EdgeInsets.only(left: 10, right: 5),
                              width: 170,
                              decoration: BoxDecoration(
                                color: AppColors.tertiary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            Icon(Icons.visibility_off, color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.onPrimary,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                      fontFamily: "SpaceMono",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      fontFamily: "SpaceMono",
                                      fontSize: 16,
                                      color: Colors.white,
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
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "PROVE ME WRONG",
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontFamily: "HectorExtenda40",
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
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