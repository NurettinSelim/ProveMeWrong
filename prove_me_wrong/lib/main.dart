import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prove_me_wrong/Screens/home_screen.dart';
import 'package:prove_me_wrong/Screens/rooms_screen.dart';
import 'package:prove_me_wrong/Screens/sign_up.dart';
import 'package:prove_me_wrong/core/data/message_adapter.dart';
import 'package:prove_me_wrong/widgets/footer.dart';
import 'package:prove_me_wrong/core/data/screens_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(RoomMetadataAdapter());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MaterialApp(home: App())));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreen = ref.watch(screenProvider);

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
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
        return SignUpScreen();
      },
    );
  }
}
