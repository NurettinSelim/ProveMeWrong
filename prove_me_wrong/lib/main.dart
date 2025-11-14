import 'package:flutter/material.dart';

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
