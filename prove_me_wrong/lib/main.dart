import 'package:flutter/material.dart';
import 'package:prove_me_wrong/Screens/home_screen.dart';
import 'package:prove_me_wrong/Widgets/footer.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

void main() {
  runApp(MaterialApp(home: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onPrimary,
      body: Stack(
        children: [
          Positioned.fill(child: HomeScreen()),
          Positioned(left: 50, right: 50, bottom: 24, child: Footer()),
        ],
      ),
    );
  }
}
