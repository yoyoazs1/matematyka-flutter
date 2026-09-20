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

      void showHistory() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Historia'),
        content: SizedBox(
          width: double.maxFinite,
          child: history.isEmpty
              ? const Text('Brak historii')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(history[i]),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zamknij'),
          )
        ],
      ),
    );
  }

  void finish() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Wyniki'),
        content: Text(
          'Poprawne: $good\n'
          'Błędne: $bad\n'
          'Nie wiem: $dontKnow',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Wróć'),
          )
        ],
      ),
    );
  }

  Widget modeButton(String name, String symbol) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: FilledButton.tonal(
          onPressed: () => changeMode(symbol),
          child: Text(name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
