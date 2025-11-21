import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prove_me_wrong/Screens/home_screen.dart';
import 'package:prove_me_wrong/Screens/rooms_screen.dart';
import 'package:prove_me_wrong/Widgets/footer.dart';
import 'package:prove_me_wrong/core/data/screens_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: App())));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreen = ref.watch(screenProvider);

    return Scaffold(
      backgroundColor: AppColors.onPrimary,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: currentScreen.index,
              children: [HomeScreen(), RoomsScreen()],
            ),
          ),
          Positioned(left: 50, right: 50, bottom: 24, child: Footer()),
        ],
      ),
    );
  }
}
