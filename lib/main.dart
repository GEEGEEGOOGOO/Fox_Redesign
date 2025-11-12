import 'package:flutter/material.dart';
import 'screens/mining_screen_layout.dart';

void main() {
  runApp(const FoxApp());
}

class FoxApp extends StatelessWidget {
  const FoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MiningScreenLayout(),
    );
  }
}
