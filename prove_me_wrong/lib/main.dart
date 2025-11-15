import 'package:flutter/material.dart';

final colorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xffa31e1e),
  onPrimary: Color(0xffede3d7),
  onPrimaryContainer: Color(0xff891b1b),
  secondary: Color(0xff6b2f2f),
  onSecondary: Color(0xfff7eaea),
  tertiary: Color(0xffd87070),

  //  Hata vermesin diye ekledim color scheme için zorunlu
  error: Colors.red,
  onError: Colors.red,
  //
  surface: Color(0xffa31e1e),
  onSurface: Color(0xfff7eaea),
  surfaceContainer: Color(0xff891b1b),
);
void main() {
  runApp(MaterialApp(home: Empty()));
}

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
