import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MathApp());

class MathApp extends StatelessWidget {
  const MathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trening matematyczny',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MathPage(),
    );
  }
}

class MathPage extends StatefulWidget {
  const MathPage({super.key});

  @override
  State<MathPage> createState() => _MathPageState();
}

class _MathPageState extends State<MathPage> {
  final rnd = Random();
  final answer = TextEditingController();

  String mode = '+';
  int a = 0, b = 0, result = 0;
  int good = 0, bad = 0, dontKnow = 0;
  String message = '';

  final
